import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyActionsWidget extends StatefulWidget {
  final VoidCallback onEmergencyContact;
  final bool isConnected;

  const EmergencyActionsWidget({
    super.key,
    required this.onEmergencyContact,
    required this.isConnected,
  });

  @override
  State<EmergencyActionsWidget> createState() => _EmergencyActionsWidgetState();
}

class _EmergencyActionsWidgetState extends State<EmergencyActionsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isExpanded = false;

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

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    HapticFeedback.lightImpact();
  }

  void _callEmergencyServices() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Emergency Call'),
          ],
        ),
        content: Text(
          'Call emergency services (119)?',
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
                  content: Text('Calling emergency services...'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Call 119'),
          ),
        ],
      ),
    );
  }

  void _shareLocation() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location shared with emergency contacts'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main emergency button
        GestureDetector(
          onTap: _toggleExpanded,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.error.withValues(
                        alpha: 0.3 + (_pulseController.value * 0.2),
                      ),
                      blurRadius: 8 + (_pulseController.value * 4),
                      spreadRadius: 2 + (_pulseController.value * 2),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: _isExpanded ? 'close' : 'emergency',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ),

        // Expanded action buttons
        if (_isExpanded) ...[
          SizedBox(height: 2.h),

          // Emergency contact button
          GestureDetector(
            onTap: widget.onEmergencyContact,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'contact_emergency',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          SizedBox(height: 1.h),

          // Call emergency services button
          GestureDetector(
            onTap: _callEmergencyServices,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error,
                shape: BoxShape.circle,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'phone',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          SizedBox(height: 1.h),

          // Share location button
          GestureDetector(
            onTap: _shareLocation,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                shape: BoxShape.circle,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'share_location',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
