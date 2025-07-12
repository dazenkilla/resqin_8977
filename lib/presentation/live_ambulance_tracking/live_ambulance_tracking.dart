import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/driver_info_card_widget.dart';
import './widgets/emergency_actions_widget.dart';
import './widgets/eta_display_widget.dart';
import './widgets/status_progress_widget.dart';
import './widgets/tracking_map_widget.dart';

class LiveAmbulanceTracking extends StatefulWidget {
  const LiveAmbulanceTracking({super.key});

  @override
  State<LiveAmbulanceTracking> createState() => _LiveAmbulanceTrackingState();
}

class _LiveAmbulanceTrackingState extends State<LiveAmbulanceTracking>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  bool _isBottomSheetExpanded = false;
  String _currentStatus = 'En route to pickup';
  int _currentStage = 1;
  String _eta = '8 min';
  bool _isConnected = true;

  // Mock booking data
  final Map<String, dynamic> _bookingData = {
    "bookingId": "RSQ-2025-001247",
    "timestamp": "2025-07-12 04:58:45",
    "pickupLocation": {
      "address": "Jl. Sudirman No. 123, Jakarta Pusat",
      "latitude": -6.2088,
      "longitude": 106.8456
    },
    "destination": {
      "address": "RS Cipto Mangunkusumo, Jakarta Pusat",
      "latitude": -6.1944,
      "longitude": 106.8317
    },
    "ambulanceLocation": {"latitude": -6.2000, "longitude": 106.8400}
  };

  // Mock driver data
  final Map<String, dynamic> _driverData = {
    "name": "Ahmad Rizki Pratama",
    "photo":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "vehicleType": "Ambulance APV",
    "licensePlate": "B 1234 RSQ",
    "phone": "+62 812-3456-7890",
    "rating": 4.8,
    "experience": "5 tahun"
  };

  final List<Map<String, dynamic>> _statusStages = [
    {"label": "Dispatched", "completed": true},
    {"label": "En Route", "completed": true},
    {"label": "Arrived", "completed": false},
    {"label": "Departed", "completed": false},
    {"label": "Delivered", "completed": false},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _simulateStatusUpdates();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _simulateStatusUpdates() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _currentStatus = 'Arrived at location';
          _currentStage = 2;
          _eta = '2 min';
          _statusStages[2] = {"label": "Arrived", "completed": true};
        });
        HapticFeedback.mediumImpact();
      }
    });

    Future.delayed(const Duration(seconds: 20), () {
      if (mounted) {
        setState(() {
          _currentStatus = 'Patient loaded - En route to hospital';
          _currentStage = 3;
          _eta = '15 min';
          _statusStages[3] = {"label": "Departed", "completed": true};
        });
        HapticFeedback.mediumImpact();
      }
    });
  }

  void _toggleBottomSheet() {
    setState(() {
      _isBottomSheetExpanded = !_isBottomSheetExpanded;
    });

    if (_isBottomSheetExpanded) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
  }

  void _callDriver() {
    HapticFeedback.lightImpact();
    // Simulate calling driver
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${(_driverData["name"] as String)}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _messageDriver() {
    HapticFeedback.lightImpact();
    // Simulate messaging driver
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Opening chat with ${(_driverData["name"] as String)}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _emergencyContact() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Emergency Contact'),
          ],
        ),
        content: Text(
          'Send emergency status update to family and hospital?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Emergency contacts notified'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              );
            },
            child: Text('Send Alert'),
          ),
        ],
      ),
    );
  }

  void _refreshData() async {
    HapticFeedback.selectionClick();
    setState(() {
      _isConnected = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isConnected = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data refreshed'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Header with booking info
                _buildHeader(),

                // Map area
                Expanded(
                  flex: 3,
                  child: TrackingMapWidget(
                    bookingData: _bookingData,
                    isConnected: _isConnected,
                    onRefresh: _refreshData,
                  ),
                ),

                // Status and ETA section
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(6.w),
                    ),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      // Status progress
                      StatusProgressWidget(
                        stages: _statusStages,
                        currentStage: _currentStage,
                      ),

                      SizedBox(height: 3.h),

                      // Current status and ETA
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Status',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    AnimatedBuilder(
                                      animation: _pulseController,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: 1.0 +
                                              (_pulseController.value * 0.1),
                                          child: Container(
                                            width: 3.w,
                                            height: 3.w,
                                            decoration: BoxDecoration(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.tertiary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: Text(
                                        _currentStatus,
                                        style: AppTheme
                                            .lightTheme.textTheme.titleMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          EtaDisplayWidget(
                            eta: _eta,
                            isConnected: _isConnected,
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Driver info toggle
                      GestureDetector(
                        onTap: _toggleBottomSheet,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme
                                .lightTheme.colorScheme.primaryContainer
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3.w),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 6.w,
                                backgroundImage: NetworkImage(
                                    _driverData["photo"] as String),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _driverData["name"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${_driverData["vehicleType"]} • ${_driverData["licensePlate"]}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedRotation(
                                turns: _isBottomSheetExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: CustomIconWidget(
                                  iconName: 'keyboard_arrow_up',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Expanded driver info
            if (_isBottomSheetExpanded)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeInOut,
                  )),
                  child: DriverInfoCardWidget(
                    driverData: _driverData,
                    onCall: _callDriver,
                    onMessage: _messageDriver,
                    onClose: _toggleBottomSheet,
                  ),
                ),
              ),

            // Emergency floating action button
            Positioned(
              top: 2.h,
              right: 4.w,
              child: EmergencyActionsWidget(
                onEmergencyContact: _emergencyContact,
                isConnected: _isConnected,
              ),
            ),

            // Connection status indicator
            if (!_isConnected)
              Positioned(
                top: 8.h,
                left: 4.w,
                right: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'wifi_off',
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Connection lost - Using cached data',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Tracking',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                Text(
                  'Booking ID: ${_bookingData["bookingId"]}',
                  style: AppTheme.dataTextTheme(isLight: true).bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.h,
            ),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  'LIVE',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
