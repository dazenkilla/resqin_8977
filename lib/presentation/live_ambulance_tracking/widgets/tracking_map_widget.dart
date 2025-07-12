import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrackingMapWidget extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final bool isConnected;
  final VoidCallback onRefresh;

  const TrackingMapWidget({
    super.key,
    required this.bookingData,
    required this.isConnected,
    required this.onRefresh,
  });

  @override
  State<TrackingMapWidget> createState() => _TrackingMapWidgetState();
}

class _TrackingMapWidgetState extends State<TrackingMapWidget>
    with TickerProviderStateMixin {
  late AnimationController _ambulanceController;
  late AnimationController _routeController;
  double _mapZoom = 15.0;
  bool _isFollowingAmbulance = true;

  @override
  void initState() {
    super.initState();
    _ambulanceController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _routeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ambulanceController.dispose();
    _routeController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _mapZoom = (_mapZoom + 1).clamp(10.0, 20.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _mapZoom = (_mapZoom - 1).clamp(10.0, 20.0);
    });
  }

  void _toggleFollowMode() {
    setState(() {
      _isFollowingAmbulance = !_isFollowingAmbulance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(6.w),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(6.w),
        ),
        child: Stack(
          children: [
            // Map placeholder with route visualization
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primaryContainer
                        .withValues(alpha: 0.1),
                    AppTheme.lightTheme.colorScheme.secondaryContainer
                        .withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Grid pattern to simulate map
                  CustomPaint(
                    size: Size(double.infinity, double.infinity),
                    painter: MapGridPainter(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),

                  // Route line
                  Positioned(
                    left: 20.w,
                    top: 30.h,
                    child: AnimatedBuilder(
                      animation: _routeController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size(60.w, 20.h),
                          painter: RoutePainter(
                            progress: _routeController.value,
                            color: AppTheme.lightTheme.colorScheme.error,
                          ),
                        );
                      },
                    ),
                  ),

                  // User location (pickup point)
                  Positioned(
                    left: 25.w,
                    top: 35.h,
                    child: _buildLocationMarker(
                      icon: 'person_pin_circle',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      label: 'Pickup',
                      isUser: true,
                    ),
                  ),

                  // Hospital location (destination)
                  Positioned(
                    right: 20.w,
                    top: 25.h,
                    child: _buildLocationMarker(
                      icon: 'local_hospital',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      label: 'Hospital',
                    ),
                  ),

                  // Ambulance location (moving)
                  Positioned(
                    left: 40.w,
                    top: 32.h,
                    child: AnimatedBuilder(
                      animation: _ambulanceController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            10 * _ambulanceController.value,
                            5 * _ambulanceController.value,
                          ),
                          child: _buildAmbulanceMarker(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Map controls
            Positioned(
              right: 4.w,
              top: 4.h,
              child: Column(
                children: [
                  _buildMapControl(
                    icon: 'add',
                    onTap: _zoomIn,
                  ),
                  SizedBox(height: 1.h),
                  _buildMapControl(
                    icon: 'remove',
                    onTap: _zoomOut,
                  ),
                  SizedBox(height: 2.h),
                  _buildMapControl(
                    icon: _isFollowingAmbulance ? 'gps_fixed' : 'gps_not_fixed',
                    onTap: _toggleFollowMode,
                    isActive: _isFollowingAmbulance,
                  ),
                ],
              ),
            ),

            // Refresh button
            Positioned(
              left: 4.w,
              top: 4.h,
              child: GestureDetector(
                onTap: widget.onRefresh,
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(3.w),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: CustomIconWidget(
                    iconName: 'refresh',
                    color: widget.isConnected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Map legend
            Positioned(
              left: 4.w,
              bottom: 4.h,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(3.w),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLegendItem(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      label: 'Pickup Location',
                    ),
                    SizedBox(height: 1.h),
                    _buildLegendItem(
                      color: AppTheme.lightTheme.colorScheme.error,
                      label: 'Ambulance',
                    ),
                    SizedBox(height: 1.h),
                    _buildLegendItem(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      label: 'Hospital',
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

  Widget _buildLocationMarker({
    required String icon,
    required Color color,
    required String label,
    bool isUser = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.w),
            boxShadow: AppTheme.cardShadow,
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 2.w,
            vertical: 0.5.h,
          ),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(1.w),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildAmbulanceMarker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _ambulanceController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_ambulanceController.value * 0.1),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error,
                  borderRadius: BorderRadius.circular(3.w),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: 'local_hospital',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 2.w,
            vertical: 0.5.h,
          ),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.error,
            borderRadius: BorderRadius.circular(1.w),
          ),
          child: Text(
            'Ambulance',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapControl({
    required String icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          boxShadow: AppTheme.cardShadow,
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: isActive
              ? Colors.white
              : AppTheme.lightTheme.colorScheme.onSurface,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall,
        ),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  final Color color;

  MapGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const gridSize = 50.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RoutePainter extends CustomPainter {
  final double progress;
  final Color color;

  RoutePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.7,
      size.width,
      size.height * 0.3,
    );

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * progress,
      );
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
