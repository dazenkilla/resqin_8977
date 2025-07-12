import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentTimerWidget extends StatelessWidget {
  final Duration remainingTime;
  final VoidCallback onExpired;

  const PaymentTimerWidget({
    Key? key,
    required this.remainingTime,
    required this.onExpired,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  Color _getTimerColor() {
    if (remainingTime.inHours >= 12) {
      return AppTheme.lightTheme.colorScheme.tertiary; // Green
    } else if (remainingTime.inHours >= 2) {
      return AppTheme.lightTheme.colorScheme.secondary; // Blue
    } else {
      return AppTheme.lightTheme.colorScheme.primary; // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerColor = _getTimerColor();
    final isUrgent = remainingTime.inHours < 2;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: timerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: timerColor,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isUrgent ? 'warning' : 'schedule',
                color: timerColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Batas Waktu Pembayaran',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: timerColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // Timer Display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: timerColor.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              _formatDuration(remainingTime),
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: timerColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(height: 1.h),

          // Timer Description
          Text(
            isUrgent
                ? 'Segera selesaikan pembayaran!'
                : 'Selesaikan pembayaran sebelum waktu habis',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: timerColor,
              fontWeight: isUrgent ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          // Progress Bar
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value:
                remainingTime.inSeconds / const Duration(hours: 24).inSeconds,
            backgroundColor: timerColor.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(timerColor),
            minHeight: 4,
          ),
        ],
      ),
    );
  }
}
