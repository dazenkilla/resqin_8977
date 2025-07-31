import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/brand_logo_widget.dart';
import './widgets/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _loadingController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  String _statusMessage = 'Initializing Ambulans...';
  bool _hasError = false;
  String _errorMessage = '';
  bool _showRetryButton = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitializationSequence();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));

    _logoController.forward();
    _loadingController.repeat();
  }

  Future<void> _startInitializationSequence() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      // Step 1: Check network connectivity
      await _checkConnectivity();

      // Step 2: Check authentication status
      await _checkAuthenticationStatus();

      // Step 3: Validate required permissions
      await _checkPermissions();

      // Step 4: Initialize app data
      await _initializeAppData();

      // Step 5: Navigate to appropriate screen
      await _navigateToNextScreen();
    } catch (e) {
      _handleInitializationError(e.toString());
    }
  }

  Future<void> _checkConnectivity() async {
    setState(() {
      _statusMessage = 'Checking network connection...';
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _statusMessage = 'Running in offline mode';
      });
      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    setState(() {
      _statusMessage = 'Checking authentication...';
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn) {
      setState(() {
        _statusMessage = 'Welcome back!';
      });
    } else {
      setState(() {
        _statusMessage = 'Preparing login...';
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _checkPermissions() async {
    setState(() {
      _statusMessage = 'Checking permissions...';
    });

    await Future.delayed(const Duration(milliseconds: 400));

    final locationStatus = await Permission.location.status;
    final cameraStatus = await Permission.camera.status;

    if (!locationStatus.isGranted || !cameraStatus.isGranted) {
      setState(() {
        _statusMessage = 'Permission setup required';
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _initializeAppData() async {
    setState(() {
      _statusMessage = 'Loading emergency data...';
    });

    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate loading hospital data, emergency contacts, etc.
    setState(() {
      _statusMessage = 'Ready for emergencies';
    });

    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    final locationStatus = await Permission.location.status;
    final cameraStatus = await Permission.camera.status;

    // Minimum splash duration for brand recognition
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    if (isLoggedIn && locationStatus.isGranted && cameraStatus.isGranted) {
      Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
    } else if (!locationStatus.isGranted || !cameraStatus.isGranted) {
      Navigator.pushReplacementNamed(
          context, AppRoutes.locationCameraPermissionScreen);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.googleLoginScreen);
    }
  }

  void _handleInitializationError(String error) {
    if (!mounted) return;

    setState(() {
      _hasError = true;
      _errorMessage = 'Failed to initialize app. Please try again.';
      _statusMessage = 'Initialization failed';
      _showRetryButton = true;
    });
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _showRetryButton = false;
      _statusMessage = 'Retrying initialization...';
    });

    _startInitializationSequence();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.secondary.withAlpha(204),
              Colors.white,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Brand Logo with Animation
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoAnimation.value,
                            child: BrandLogoWidget(
                              logoController: _logoController,
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 8.h),

                      // Loading Animation
                      if (!_hasError) ...[
                        LoadingAnimationWidget(
                          loadingController: _loadingController,
                        ),

                        SizedBox(height: 4.h),

                        // Status Message
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            _statusMessage,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],

                      // Error State
                      if (_hasError) ...[
                        Icon(
                          Icons.error_outline,
                          size: 48.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _errorMessage,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_showRetryButton) ...[
                          SizedBox(height: 3.h),
                          ElevatedButton(
                            onPressed: _retryInitialization,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                            ),
                            child: Text(
                              'Retry',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),

              // Version Information
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'ambulans.co v1.0.0',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withAlpha(179),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}