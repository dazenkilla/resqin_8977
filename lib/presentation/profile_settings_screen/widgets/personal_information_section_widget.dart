import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalInformationSectionWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PersonalInformationSectionWidget({
    super.key,
    required this.userData,
  });

  @override
  State<PersonalInformationSectionWidget> createState() =>
      _PersonalInformationSectionWidgetState();
}

class _PersonalInformationSectionWidgetState
    extends State<PersonalInformationSectionWidget> {
  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  late String _selectedBloodType;
  late TextEditingController _allergiesController;
  late TextEditingController _medicalConditionsController;

  @override
  void initState() {
    super.initState();
    _selectedBloodType = widget.userData['bloodType'] ?? 'O+';
    _allergiesController = TextEditingController(
      text: (widget.userData['allergies'] as List<dynamic>?)?.join(', ') ?? '',
    );
    _medicalConditionsController = TextEditingController(
      text: (widget.userData['medicalConditions'] as List<dynamic>?)
              ?.join(', ') ??
          '',
    );
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    _medicalConditionsController.dispose();
    super.dispose();
  }

  void _handleEmergencyContactEdit(int index) {
    final contacts =
        widget.userData['emergencyContacts'] as List<dynamic>? ?? [];
    if (index < contacts.length) {
      _showEmergencyContactDialog(contacts[index], index);
    }
  }

  void _handleAddEmergencyContact() {
    _showEmergencyContactDialog(null, -1);
  }

  void _showEmergencyContactDialog(Map<String, dynamic>? contact, int index) {
    final nameController = TextEditingController(text: contact?['name'] ?? '');
    final phoneController =
        TextEditingController(text: contact?['phone'] ?? '');
    String selectedRelationship = contact?['relationship'] ?? 'Spouse';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                index == -1
                    ? 'Add Emergency Contact'
                    : 'Edit Emergency Contact',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter contact name',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    DropdownButtonFormField<String>(
                      value: selectedRelationship,
                      decoration: const InputDecoration(
                        labelText: 'Relationship',
                      ),
                      items: [
                        'Spouse',
                        'Parent',
                        'Child',
                        'Sibling',
                        'Friend',
                        'Other'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          selectedRelationship = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+62-812-3456-7890',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate phone number
                    if (_validatePhoneNumber(phoneController.text)) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Emergency contact saved successfully'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid phone number'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _validatePhoneNumber(String phone) {
    // Basic phone validation - contains digits and common formatting
    final phoneRegex = RegExp(r'^\+?[0-9\-\s\(\)]{10,}$');
    return phoneRegex.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    final emergencyContacts =
        widget.userData['emergencyContacts'] as List<dynamic>? ?? [];

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
                  iconName: 'person',
                  size: 24,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Personal Information',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Blood Type Selection
            Text(
              'Blood Type',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            DropdownButtonFormField<String>(
              value: _selectedBloodType,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: _bloodTypes.map((String bloodType) {
                return DropdownMenuItem<String>(
                  value: bloodType,
                  child: Text(bloodType),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBloodType = newValue!;
                });
              },
            ),
            SizedBox(height: 3.h),

            // Medical Conditions
            Text(
              'Medical Conditions',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: _medicalConditionsController,
              decoration: const InputDecoration(
                hintText: 'Enter medical conditions separated by commas',
              ),
              maxLines: 2,
            ),
            SizedBox(height: 3.h),

            // Allergies
            Text(
              'Allergies',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: _allergiesController,
              decoration: const InputDecoration(
                hintText: 'Enter allergies separated by commas',
              ),
              maxLines: 2,
            ),
            SizedBox(height: 3.h),

            // Emergency Contacts
            Row(
              children: [
                Text(
                  'Emergency Contacts',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _handleAddEmergencyContact,
                  icon: CustomIconWidget(
                    iconName: 'add',
                    size: 16,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                  label: const Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 1.h),

            // Emergency Contacts List
            ...emergencyContacts.asMap().entries.map((entry) {
              final index = entry.key;
              final contact = entry.value as Map<String, dynamic>;

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact['name'] ?? '',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${contact['relationship']} • ${contact['phone']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _handleEmergencyContactEdit(index),
                      icon: CustomIconWidget(
                        iconName: 'edit',
                        size: 20,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
