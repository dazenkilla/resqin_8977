import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/camera_permission_card_widget.dart';
import './widgets/location_permission_card_widget.dart';
import './widgets/permission_actions_widget.dart';
import './widgets/permission_header_widget.dart';
import './widgets/privacy_info_widget.dart';

class LocationCameraPermissionScreen extends StatefulWidget {
  const LocationCameraPermissionScreen({Key? key}) : super(key: key);

  @override
  State<LocationCameraPermissionScreen> createState() =>
      _LocationCameraPermissionScreenState();
}

class _LocationCameraPermissionScreenState
    extends State<LocationCameraPermissionScreen> {
  bool _isLocationGranted = false;
  bool _isCameraGranted = false;
  bool _isLoading = false;
  bool _showPrivacyInfo = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentPermissions();
  }

  Future<void> _checkCurrentPermissions() async {
    final locationStatus = await Permission.location.status;
    final cameraStatus = await Permission.camera.status;

    setState(() {
      _isLocationGranted = locationStatus.isGranted;
      _isCameraGranted = cameraStatus.isGranted;
    });
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    setState(() {
      _isLocationGranted = status.isGranted;
    });

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog('Location');
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isCameraGranted = status.isGranted;
    });

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog('Camera');
    }
  }

  Future<void> _requestAllPermissions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Map<Permission, PermissionStatus> statuses =
          await [Permission.location, Permission.camera].request();

      setState(() {
        _isLocationGranted = statuses[Permission.location]?.isGranted ?? false;
        _isCameraGranted = statuses[Permission.camera]?.isGranted ?? false;
      });

      if (_isLocationGranted && _isCameraGranted) {
        await _navigateToHome();
      } else {
        _showPartialPermissionDialog();
      }
    } catch (e) {
      _showErrorDialog('Failed to request permissions. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _skipPermissions() async {
    final confirmed = await _showSkipConfirmationDialog();
    if (confirmed) {
      await _navigateToNextScreen();
    }
  }

  Future<void> _navigateToHome() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.googleLoginScreen);
    }
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.googleLoginScreen);
    }
  }

  void _showPermissionDeniedDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '$permissionType Permission Required',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Please enable $permissionType permission in Settings to use all Ambulans.co features.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showPartialPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Partial Permissions',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Some features may be limited without all permissions. You can enable them later in Settings.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _requestAllPermissions();
            },
            child: Text('Try Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToNextScreen();
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showSkipConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Skip Permissions?',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Without these permissions, you may not be able to:\n\n• Get accurate ambulance pickup location\n• Scan receipts for payment verification\n• Access emergency features quickly',
              style: GoogleFonts.inter(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Skip Anyway'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Error',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            PermissionHeaderWidget(),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    // Location Permission Card
                    LocationPermissionCardWidget(
                      isGranted: _isLocationGranted,
                      onTap: _requestLocationPermission,
                    ),

                    SizedBox(height: 3.h),

                    // Camera Permission Card
                    CameraPermissionCardWidget(
                      isGranted: _isCameraGranted,
                      onTap: _requestCameraPermission,
                    ),

                    SizedBox(height: 4.h),

                    // Privacy Information
                    PrivacyInfoWidget(
                      isExpanded: _showPrivacyInfo,
                      onToggle: () {
                        setState(() {
                          _showPrivacyInfo = !_showPrivacyInfo;
                        });
                      },
                    ),

                    SizedBox(height: 6.h),
                  ],
                ),
              ),
            ),

            // Action Buttons
            PermissionActionsWidget(
              isLocationGranted: _isLocationGranted,
              isCameraGranted: _isCameraGranted,
              isLoading: _isLoading,
              onGrantPermissions: _requestAllPermissions,
              onSkip: _skipPermissions,
            ),
          ],
        ),
      ),
    );
  }
}
