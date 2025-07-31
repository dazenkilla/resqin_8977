import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacyControlsSectionWidget extends StatefulWidget {
  const PrivacyControlsSectionWidget({super.key});

  @override
  State<PrivacyControlsSectionWidget> createState() =>
      _PrivacyControlsSectionWidgetState();
}

class _PrivacyControlsSectionWidgetState
    extends State<PrivacyControlsSectionWidget> {
  bool _shareDataWithPartners = false;
  bool _locationHistory = true;
  bool _analyticsData = true;
  bool _crashReporting = true;
  String _dataRetentionPeriod = '2_years';

  final List<Map<String, String>> _retentionOptions = [
    {'value': '1_year', 'label': '1 Year'},
    {'value': '2_years', 'label': '2 Years'},
    {'value': '5_years', 'label': '5 Years'},
    {'value': 'indefinite', 'label': 'Indefinite'},
  ];

  void _handleDataDeletion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account Data',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This action will permanently delete:',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              _buildDeletionItem('Personal information and profile data'),
              _buildDeletionItem('Booking history and medical records'),
              _buildDeletionItem('Payment methods and receipts'),
              _buildDeletionItem('Location history and preferences'),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.error.withAlpha(77),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'warning',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'This action cannot be undone. You will lose access to emergency services.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showFinalConfirmation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeletionItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'check',
            size: 16,
            color: AppTheme.lightTheme.colorScheme.error,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _showFinalConfirmation() {
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Final Confirmation',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Type "DELETE" to confirm account deletion:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: confirmController,
                decoration: const InputDecoration(
                  hintText: 'Type DELETE here',
                ),
                textCapitalization: TextCapitalization.characters,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (confirmController.text.trim() == 'DELETE') {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Account deletion request initiated. You will receive an email confirmation.'),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please type "DELETE" exactly to confirm'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: const Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }

  void _handleDataExport() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Export Personal Data',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your data will be compiled and sent to your registered email address. This may take up to 48 hours.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Data will be provided in JSON format for easy processing.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Data export request submitted. Check your email in 24-48 hours.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Request Export'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrivacyToggle({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required String iconName,
    bool isRecommended = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 24,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isRecommended)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary
                              .withAlpha(51),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Recommended',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
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
            onChanged: onChanged,
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
                  iconName: 'privacy_tip',
                  size: 24,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Privacy Controls',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Data Sharing
            Text(
              'Data Sharing',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            _buildPrivacyToggle(
              title: 'Share with Hospital Partners',
              subtitle:
                  'Allow hospitals to access your medical information during emergencies',
              value: _shareDataWithPartners,
              onChanged: (value) =>
                  setState(() => _shareDataWithPartners = value),
              iconName: 'local_hospital',
            ),

            _buildPrivacyToggle(
              title: 'Location History',
              subtitle: 'Save location data to improve service recommendations',
              value: _locationHistory,
              onChanged: (value) => setState(() => _locationHistory = value),
              iconName: 'location_history',
              isRecommended: true,
            ),

            _buildPrivacyToggle(
              title: 'Analytics Data',
              subtitle:
                  'Help improve the app through anonymous usage analytics',
              value: _analyticsData,
              onChanged: (value) => setState(() => _analyticsData = value),
              iconName: 'analytics',
            ),

            _buildPrivacyToggle(
              title: 'Crash Reporting',
              subtitle: 'Automatically send crash reports to help fix bugs',
              value: _crashReporting,
              onChanged: (value) => setState(() => _crashReporting = value),
              iconName: 'bug_report',
              isRecommended: true,
            ),

            SizedBox(height: 2.h),

            // Data Retention
            Text(
              'Data Retention',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keep my data for',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        DropdownButtonFormField<String>(
                          value: _dataRetentionPeriod,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items: _retentionOptions.map((option) {
                            return DropdownMenuItem<String>(
                              value: option['value'],
                              child: Text(option['label']!),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _dataRetentionPeriod = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Account Actions
            Text(
              'Account Management',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            // Export Data Button
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 1.h),
              child: OutlinedButton.icon(
                onPressed: _handleDataExport,
                icon: CustomIconWidget(
                  iconName: 'download',
                  size: 20,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                label: const Text('Export My Data'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),

            // Delete Account Button
            Container(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _handleDataDeletion,
                icon: CustomIconWidget(
                  iconName: 'delete_forever',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
                label: const Text('Delete Account'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.error,
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
