import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesSectionWidget extends StatefulWidget {
  const NotificationPreferencesSectionWidget({super.key});

  @override
  State<NotificationPreferencesSectionWidget> createState() =>
      _NotificationPreferencesSectionWidgetState();
}

class _NotificationPreferencesSectionWidgetState
    extends State<NotificationPreferencesSectionWidget> {
  bool _emergencyAlerts = true;
  bool _bookingUpdates = true;
  bool _promotionalMessages = false;
  bool _driverLocation = true;
  bool _arrivalNotifications = true;
  bool _paymentConfirmations = true;

  void _handleNotificationToggle(String type, bool value) {
    setState(() {
      switch (type) {
        case 'emergency':
          _emergencyAlerts = value;
          break;
        case 'booking':
          _bookingUpdates = value;
          break;
        case 'promotional':
          _promotionalMessages = value;
          break;
        case 'driver':
          _driverLocation = value;
          break;
        case 'arrival':
          _arrivalNotifications = value;
          break;
        case 'payment':
          _paymentConfirmations = value;
          break;
      }
    });

    // Show feedback for critical notifications
    if (type == 'emergency' && !value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Warning: Emergency alerts are critical for your safety'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required String type,
    required IconData icon,
    bool isImportant = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isImportant
            ? AppTheme.lightTheme.primaryColor.withAlpha(13)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isImportant
              ? AppTheme.lightTheme.primaryColor.withAlpha(77)
              : AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon.toString().split('.').last,
            size: 24,
            color: isImportant
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color:
                        isImportant ? AppTheme.lightTheme.primaryColor : null,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) => _handleNotificationToggle(type, newValue),
            activeColor: isImportant
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  size: 24,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Notification Preferences',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Critical Notifications
            Text(
              'Critical Notifications',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(height: 1.h),

            _buildNotificationTile(
              title: 'Emergency Alerts',
              subtitle: 'Critical emergency notifications and SOS responses',
              value: _emergencyAlerts,
              type: 'emergency',
              icon: Icons.emergency,
              isImportant: true,
            ),

            _buildNotificationTile(
              title: 'Arrival Notifications',
              subtitle: 'When your ambulance arrives at pickup location',
              value: _arrivalNotifications,
              type: 'arrival',
              icon: Icons.location_on,
              isImportant: true,
            ),

            SizedBox(height: 2.h),

            // Service Updates
            Text(
              'Service Updates',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            _buildNotificationTile(
              title: 'Booking Updates',
              subtitle: 'Status changes for your ambulance bookings',
              value: _bookingUpdates,
              type: 'booking',
              icon: Icons.update,
            ),

            _buildNotificationTile(
              title: 'Driver Location',
              subtitle: 'Real-time location updates of your assigned driver',
              value: _driverLocation,
              type: 'driver',
              icon: Icons.my_location,
            ),

            _buildNotificationTile(
              title: 'Payment Confirmations',
              subtitle: 'Payment receipts and transaction confirmations',
              value: _paymentConfirmations,
              type: 'payment',
              icon: Icons.payment,
            ),

            SizedBox(height: 2.h),

            // Marketing
            Text(
              'Marketing',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            _buildNotificationTile(
              title: 'Promotional Messages',
              subtitle: 'Special offers, discounts, and service announcements',
              value: _promotionalMessages,
              type: 'promotional',
              icon: Icons.local_offer,
            ),
          ],
        ),
      ),
    );
  }
}
