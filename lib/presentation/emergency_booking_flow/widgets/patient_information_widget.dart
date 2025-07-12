import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PatientInformationWidget extends StatefulWidget {
  final Function(String, Map<String, String>?) onPatientInfoSubmitted;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final String initialCondition;
  final Map<String, String>? initialContact;

  const PatientInformationWidget({
    Key? key,
    required this.onPatientInfoSubmitted,
    required this.onNext,
    required this.onBack,
    required this.initialCondition,
    this.initialContact,
  }) : super(key: key);

  @override
  State<PatientInformationWidget> createState() =>
      _PatientInformationWidgetState();
}

class _PatientInformationWidgetState extends State<PatientInformationWidget> {
  final TextEditingController _conditionController = TextEditingController();
  Map<String, String>? _selectedContact;
  bool _showSuggestions = false;

  final List<String> medicalTerminologySuggestions = [
    'Chest pain',
    'Difficulty breathing',
    'Unconscious',
    'Severe bleeding',
    'Cardiac arrest',
    'Stroke symptoms',
    'Allergic reaction',
    'Fracture',
    'Burns',
    'Seizure',
    'High fever',
    'Abdominal pain',
    'Head injury',
    'Diabetic emergency',
    'Pregnancy complications',
  ];

  final List<Map<String, String>> mockContacts = [
    {
      'name': 'Dr. Sarah Wijaya',
      'phone': '+62 812-3456-7890',
      'relation': 'Family Doctor',
      'type': 'Medical',
    },
    {
      'name': 'Ahmad Santoso',
      'phone': '+62 821-9876-5432',
      'relation': 'Spouse',
      'type': 'Family',
    },
    {
      'name': 'Siti Nurhaliza',
      'phone': '+62 813-2468-1357',
      'relation': 'Mother',
      'type': 'Family',
    },
    {
      'name': 'Budi Hartono',
      'phone': '+62 856-7890-1234',
      'relation': 'Brother',
      'type': 'Family',
    },
    {
      'name': 'Emergency Contact',
      'phone': '+62 119',
      'relation': 'Emergency Services',
      'type': 'Emergency',
    },
  ];

  @override
  void initState() {
    super.initState();
    _conditionController.text = widget.initialCondition;
    _selectedContact = widget.initialContact;
  }

  void _addSuggestionToCondition(String suggestion) {
    final currentText = _conditionController.text;
    final newText =
        currentText.isEmpty ? suggestion : '$currentText, $suggestion';
    _conditionController.text = newText;
    setState(() {
      _showSuggestions = false;
    });
  }

  void _updatePatientInfo() {
    widget.onPatientInfoSubmitted(_conditionController.text, _selectedContact);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Information',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Provide patient condition details and emergency contact information.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Patient Condition Section
          _buildSectionHeader('Patient Condition', 'medical_information'),
          SizedBox(height: 2.h),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _conditionController,
                  maxLines: 4,
                  onChanged: (value) {
                    setState(() {
                      _showSuggestions = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText:
                        'Describe patient condition, symptoms, or medical emergency...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(4.w),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showSuggestions = !_showSuggestions;
                        });
                      },
                      icon: CustomIconWidget(
                        iconName: _showSuggestions
                            ? 'keyboard_arrow_up'
                            : 'keyboard_arrow_down',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                if (_showSuggestions) ...[
                  Divider(
                    height: 1,
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Common Medical Terms',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Wrap(
                          spacing: 2.w,
                          runSpacing: 1.h,
                          children:
                              medicalTerminologySuggestions.map((suggestion) {
                            return InkWell(
                              onTap: () =>
                                  _addSuggestionToCondition(suggestion),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  suggestion,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Emergency Contact Section
          _buildSectionHeader('Emergency Contact', 'contact_phone'),
          SizedBox(height: 2.h),

          Text(
            'Select an emergency contact to notify',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),

          ...mockContacts.map((contact) => _buildContactCard(contact)),

          SizedBox(height: 2.h),

          // Add custom contact option
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'add_circle_outline',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Add Custom Contact',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Add a new emergency contact from your phone contacts',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                OutlinedButton(
                  onPressed: () {
                    // Simulate contact picker
                    _showAddContactDialog();
                  },
                  child: Text('Browse Contacts'),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Navigation buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text('Back'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _conditionController.text.isNotEmpty &&
                          _selectedContact != null
                      ? () {
                          _updatePatientInfo();
                          widget.onNext();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Continue',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String iconName) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard(Map<String, String> contact) {
    final bool isSelected = _selectedContact != null &&
        _selectedContact!['name'] == contact['name'];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedContact = contact;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05)
                : AppTheme.lightTheme.colorScheme.surface,
          ),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: _getContactTypeColor(contact['type']!)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: _getContactTypeIcon(contact['type']!),
                  color: _getContactTypeColor(contact['type']!),
                  size: 24,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name']!,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : null,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      contact['phone']!,
                      style: AppTheme.dataTextTheme(isLight: true)
                          .bodyMedium
                          ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getContactTypeColor(contact['type']!)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        contact['relation']!,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: _getContactTypeColor(contact['type']!),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getContactTypeColor(String type) {
    switch (type) {
      case 'Medical':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'Emergency':
        return AppTheme.lightTheme.colorScheme.error;
      case 'Family':
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _getContactTypeIcon(String type) {
    switch (type) {
      case 'Medical':
        return 'medical_services';
      case 'Emergency':
        return 'emergency';
      case 'Family':
      default:
        return 'person';
    }
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Emergency Contact',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This feature would normally access your device contacts. For this demo, you can select from the existing contacts above.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            CustomIconWidget(
              iconName: 'contacts',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 48,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _conditionController.dispose();
    super.dispose();
  }
}
