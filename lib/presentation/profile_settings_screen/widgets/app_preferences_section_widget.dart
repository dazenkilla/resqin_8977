import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppPreferencesSectionWidget extends StatefulWidget {
  const AppPreferencesSectionWidget({super.key});

  @override
  State<AppPreferencesSectionWidget> createState() =>
      _AppPreferencesSectionWidgetState();
}

class _AppPreferencesSectionWidgetState
    extends State<AppPreferencesSectionWidget> {
  String _selectedLanguage = 'english';
  String _selectedTheme = 'light';
  bool _hapticFeedback = true;
  bool _soundEffects = true;
  bool _largeText = false;
  bool _screenReader = false;
  bool _highContrast = false;
  double _textScale = 1.0;

  final List<Map<String, String>> _languages = [
    {'value': 'english', 'label': 'English', 'native': 'English'},
    {
      'value': 'indonesian',
      'label': 'Indonesian',
      'native': 'Bahasa Indonesia'
    },
    {'value': 'chinese', 'label': 'Chinese', 'native': '中文'},
    {'value': 'arabic', 'label': 'Arabic', 'native': 'العربية'},
    {'value': 'spanish', 'label': 'Spanish', 'native': 'Español'},
  ];

  final List<Map<String, String>> _themes = [
    {
      'value': 'light',
      'label': 'Light Theme',
      'description': 'Default bright appearance'
    },
    {
      'value': 'dark',
      'label': 'Dark Theme',
      'description': 'Better for low light conditions'
    },
    {'value': 'auto', 'label': 'Auto', 'description': 'Follow system settings'},
  ];

  void _handleLanguageChange(String newLanguage) {
    setState(() {
      _selectedLanguage = newLanguage;
    });

    // Show restart dialog for language change
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Language Changed',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'The app language will change after restarting. Restart now?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Simulate app restart
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Language updated successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _handleThemeChange(String newTheme) {
    setState(() {
      _selectedTheme = newTheme;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Theme changed to ${_themes.firstWhere((t) => t['value'] == newTheme)['label']}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAccessibilityChange() {
    // Show info about accessibility changes
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Accessibility settings updated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildPreferenceDropdown({
    required String title,
    required String subtitle,
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
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
                          if (option['native'] != null)
                            Text(
                              option['native']!,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
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

  Widget _buildPreferenceToggle({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required String iconName,
    bool showBadge = false,
    String? badgeText,
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
                    if (showBadge && badgeText != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor.withAlpha(51),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badgeText,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
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

  Widget _buildTextScaleSlider() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'text_fields',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text Size',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Adjust text size for better readability',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                'A',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Expanded(
                child: Slider(
                  value: _textScale,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  label: '${(_textScale * 100).round()}%',
                  onChanged: (value) {
                    setState(() {
                      _textScale = value;
                    });
                  },
                ),
              ),
              Text(
                'A',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withAlpha(26),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Sample text with current size',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize:
                    (AppTheme.lightTheme.textTheme.bodyMedium?.fontSize ?? 14) *
                        _textScale,
              ),
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
                  iconName: 'settings',
                  size: 24,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                SizedBox(width: 2.w),
                Text(
                  'App Preferences',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Language & Theme
            Text(
              'Appearance',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            _buildPreferenceDropdown(
              title: 'Language',
              subtitle: 'Choose your preferred language',
              currentValue: _selectedLanguage,
              options: _languages,
              onChanged: _handleLanguageChange,
              iconName: 'language',
            ),

            _buildPreferenceDropdown(
              title: 'Theme',
              subtitle: 'Select light, dark, or automatic theme',
              currentValue: _selectedTheme,
              options: _themes,
              onChanged: _handleThemeChange,
              iconName: 'brightness_6',
            ),

            SizedBox(height: 2.h),

            // Interface Settings
            Text(
              'Interface',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            _buildPreferenceToggle(
              title: 'Haptic Feedback',
              subtitle:
                  'Vibration feedback for button presses and interactions',
              value: _hapticFeedback,
              onChanged: (value) => setState(() => _hapticFeedback = value),
              iconName: 'vibration',
            ),

            _buildPreferenceToggle(
              title: 'Sound Effects',
              subtitle: 'Audio feedback for notifications and alerts',
              value: _soundEffects,
              onChanged: (value) => setState(() => _soundEffects = value),
              iconName: 'volume_up',
            ),

            SizedBox(height: 2.h),

            // Accessibility Settings
            Text(
              'Accessibility',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            _buildTextScaleSlider(),
            SizedBox(height: 1.h),

            _buildPreferenceToggle(
              title: 'Large Text',
              subtitle: 'Increase text size for better readability',
              value: _largeText,
              onChanged: (value) {
                setState(() => _largeText = value);
                _handleAccessibilityChange();
              },
              iconName: 'text_increase',
            ),

            _buildPreferenceToggle(
              title: 'Screen Reader Support',
              subtitle: 'Enhanced compatibility with screen readers',
              value: _screenReader,
              onChanged: (value) {
                setState(() => _screenReader = value);
                _handleAccessibilityChange();
              },
              iconName: 'accessibility',
              showBadge: _screenReader,
              badgeText: 'Active',
            ),

            _buildPreferenceToggle(
              title: 'High Contrast',
              subtitle: 'Improve visibility with high contrast colors',
              value: _highContrast,
              onChanged: (value) {
                setState(() => _highContrast = value);
                _handleAccessibilityChange();
              },
              iconName: 'contrast',
            ),
          ],
        ),
      ),
    );
  }
}
