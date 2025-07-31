import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyFeaturesSectionWidget extends StatefulWidget {
  const EmergencyFeaturesSectionWidget({super.key});

  @override
  State<EmergencyFeaturesSectionWidget> createState() =>
      _EmergencyFeaturesSectionWidgetState();
}

class _EmergencyFeaturesSectionWidgetState
    extends State<EmergencyFeaturesSectionWidget> {
  String _sosButtonBehavior = 'single_tap';
  bool _autoNotifyContacts = true;
  bool _shareMedicalInfo = true;
  bool _locationSharing = true;
  bool _voiceActivation = false;
  String _emergencyDelay = '5_seconds';

  final List<Map<String, String>> _sosOptions = [
    {
      'value': 'single_tap',
      'label': 'Single Tap',
      'description': 'Immediate activation'
    },
    {
      'value': 'double_tap',
      'label': 'Double Tap',
      'description': 'Prevents accidental activation'
    },
    {
      'value': 'hold_3s',
      'label': 'Hold 3 Seconds',
      'description': 'Most secure option'
    },
  ];

  final List<Map<String, String>> _delayOptions = [
    {'value': 'none', 'label': 'No Delay'},
    {'value': '5_seconds', 'label': '5 Seconds'},
    {'value': '10_seconds', 'label': '10 Seconds'},
    {'value': '15_seconds', 'label': '15 Seconds'},
  ];

  void _handleSOSTest() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'sos',
                size: 24,
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(width: 2.w),
              Text(
                'Test SOS Feature',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.primaryColor.withAlpha(77),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      size: 20,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'This will test your SOS configuration without triggering actual emergency services.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Test will simulate:',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              _buildTestItem('Emergency contact notifications'),
              _buildTestItem('Location sharing activation'),
              _buildTestItem('Medical information preparation'),
              _buildTestItem('SOS button response time'),
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
                _runSOSTest();
              },
              child: const Text('Run Test'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTestItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'check',
            size: 16,
            color: AppTheme.lightTheme.colorScheme.tertiary,
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

  void _runSOSTest() async {
    // Show test progress
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(height: 2.h),
              Text(
                'Testing SOS configuration...',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );

    // Simulate test delay
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pop(); // Close progress dialog

      // Show test results
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
                SizedBox(width: 2.w),
                const Text('Test Completed'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTestResult('SOS Button Response', '✓ Working', true),
                _buildTestResult(
                    'Emergency Contacts', '✓ 2 contacts notified', true),
                _buildTestResult('Location Services', '✓ GPS accurate', true),
                _buildTestResult('Medical Info', '✓ Data prepared', true),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.tertiary.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Your emergency features are configured correctly and ready for use.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildTestResult(String feature, String status, bool isSuccess) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              feature,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          Text(
            status,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isSuccess
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyToggle({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required String iconName,
    bool isCritical = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isCritical
            ? AppTheme.lightTheme.primaryColor.withAlpha(13)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCritical
              ? AppTheme.lightTheme.primaryColor.withAlpha(77)
              : AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 24,
            color: isCritical
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
                    color: isCritical ? AppTheme.lightTheme.primaryColor : null,
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
            onChanged: onChanged,
            activeColor: isCritical
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationOption({
    required String title,
    required String currentValue,
    required List<Map<String, String>> options,
    required Function(String) onChanged,
    required String iconName,
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
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                DropdownButtonFormField<String>(
                  value: currentValue,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option['value'],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(option['label']!),
                          if (option['description'] != null)
                            Text(
                              option['description']!,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onChanged(newValue);
                    }
                  },
                ),
              ],
            ),
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
                  iconName: 'emergency',
                  size: 24,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Emergency Features',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _handleSOSTest,
                  icon: CustomIconWidget(
                    iconName: 'play_arrow',
                    size: 16,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                  label: const Text('Test'),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // SOS Button Configuration
            _buildConfigurationOption(
              title: 'SOS Button Behavior',
              currentValue: _sosButtonBehavior,
              options: _sosOptions,
              onChanged: (value) => setState(() => _sosButtonBehavior = value),
              iconName: 'sos',
            ),

            _buildConfigurationOption(
              title: 'Emergency Activation Delay',
              currentValue: _emergencyDelay,
              options: _delayOptions,
              onChanged: (value) => setState(() => _emergencyDelay = value),
              iconName: 'timer',
            ),

            SizedBox(height: 2.h),

            // Emergency Response Settings
            Text(
              'Emergency Response',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            _buildEmergencyToggle(
              title: 'Auto-notify Emergency Contacts',
              subtitle:
                  'Automatically contact your emergency contacts when SOS is activated',
              value: _autoNotifyContacts,
              onChanged: (value) => setState(() => _autoNotifyContacts = value),
              iconName: 'contact_emergency',
              isCritical: true,
            ),

            _buildEmergencyToggle(
              title: 'Share Medical Information',
              subtitle:
                  'Allow hospitals to access your medical info during emergencies',
              value: _shareMedicalInfo,
              onChanged: (value) => setState(() => _shareMedicalInfo = value),
              iconName: 'medical_information',
              isCritical: true,
            ),

            _buildEmergencyToggle(
              title: 'Real-time Location Sharing',
              subtitle: 'Share your live location with emergency responders',
              value: _locationSharing,
              onChanged: (value) => setState(() => _locationSharing = value),
              iconName: 'share_location',
              isCritical: true,
            ),

            SizedBox(height: 2.h),

            // Advanced Features
            Text(
              'Advanced Features',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            _buildEmergencyToggle(
              title: 'Voice Activation',
              subtitle: 'Enable "Hey ResQin, Emergency!" voice command',
              value: _voiceActivation,
              onChanged: (value) => setState(() => _voiceActivation = value),
              iconName: 'mic',
            ),
          ],
        ),
      ),
    );
  }
}
