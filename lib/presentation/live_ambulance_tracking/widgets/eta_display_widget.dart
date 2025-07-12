import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EtaDisplayWidget extends StatefulWidget {
  final String eta;
  final bool isConnected;

  const EtaDisplayWidget({
    super.key,
    required this.eta,
    required this.isConnected,
  });

  @override
  State<EtaDisplayWidget> createState() => _EtaDisplayWidgetState();
}

class _EtaDisplayWidgetState extends State<EtaDisplayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: widget.isConnected
                        ? 1.0 + (_pulseController.value * 0.1)
                        : 1.0,
                    child: CustomIconWidget(
                      iconName: 'schedule',
                      color: Colors.white,
                      size: 20,
                    ),
                  );
                },
              ),
              SizedBox(width: 2.w),
              Text(
                'ETA',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.eta,
                style:
                    AppTheme.dataTextTheme(isLight: true).bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
              ),
              if (!widget.isConnected) ...[
                SizedBox(width: 2.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(
                    'CACHED',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 8.sp,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
