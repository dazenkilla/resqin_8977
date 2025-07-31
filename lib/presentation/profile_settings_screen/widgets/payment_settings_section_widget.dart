import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentSettingsSectionWidget extends StatefulWidget {
  const PaymentSettingsSectionWidget({super.key});

  @override
  State<PaymentSettingsSectionWidget> createState() =>
      _PaymentSettingsSectionWidgetState();
}

class _PaymentSettingsSectionWidgetState
    extends State<PaymentSettingsSectionWidget> {
  String _defaultPaymentMethod = 'credit_card';
  bool _saveReceipts = true;
  bool _emailReceipts = true;
  bool _autoPayment = false;

  // Mock payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'credit_card',
      'type': 'Credit Card',
      'details': '**** **** **** 1234',
      'icon': 'credit_card',
      'isDefault': true,
    },
    {
      'id': 'debit_card',
      'type': 'Debit Card',
      'details': '**** **** **** 5678',
      'icon': 'credit_card',
      'isDefault': false,
    },
    {
      'id': 'digital_wallet',
      'type': 'Digital Wallet',
      'details': 'GoPay Balance: Rp 150.000',
      'icon': 'account_balance_wallet',
      'isDefault': false,
    },
  ];

  void _handleAddPaymentMethod() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Payment Method',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'credit_card',
                  size: 24,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                title: const Text('Credit/Debit Card'),
                subtitle: const Text('Visa, Mastercard, etc.'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showCardInputDialog();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'account_balance_wallet',
                  size: 24,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                title: const Text('Digital Wallet'),
                subtitle: const Text('GoPay, OVO, DANA'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showWalletSelectionDialog();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'account_balance',
                  size: 24,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                title: const Text('Bank Transfer'),
                subtitle: const Text('Direct bank transfer'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showBankSelectionDialog();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showCardInputDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening secure card input form...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showWalletSelectionDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connecting to digital wallet services...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showBankSelectionDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Redirecting to bank selection...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handlePaymentMethodTap(String methodId) {
    setState(() {
      _defaultPaymentMethod = methodId;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default payment method updated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleDeletePaymentMethod(String methodId) {
    if (_paymentMethods.where((method) => method['id'] != methodId).length <
        1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must have at least one payment method'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Payment Method'),
          content: const Text(
              'Are you sure you want to remove this payment method?'),
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
                    content: Text('Payment method removed'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentMethodTile(Map<String, dynamic> method) {
    final bool isSelected = _defaultPaymentMethod == method['id'];

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.dividerColor,
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? AppTheme.lightTheme.primaryColor.withAlpha(13)
            : AppTheme.lightTheme.colorScheme.surface,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        leading: CustomIconWidget(
          iconName: method['icon'],
          size: 24,
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
        title: Text(
          method['type'],
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.lightTheme.primaryColor : null,
          ),
        ),
        subtitle: Text(
          method['details'],
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Default',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            SizedBox(width: 2.w),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _handleDeletePaymentMethod(method['id']);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Remove'),
                ),
              ],
              child: CustomIconWidget(
                iconName: 'more_vert',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        onTap: () => _handlePaymentMethodTap(method['id']),
      ),
    );
  }

  Widget _buildSettingsToggle({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
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
                  iconName: 'payment',
                  size: 24,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Payment Settings',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Saved Payment Methods
            Row(
              children: [
                Text(
                  'Saved Payment Methods',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _handleAddPaymentMethod,
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

            // Payment Methods List
            ..._paymentMethods
                .map((method) => _buildPaymentMethodTile(method))
                .toList(),

            SizedBox(height: 2.h),

            // Receipt Settings
            Text(
              'Receipt Settings',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),

            _buildSettingsToggle(
              title: 'Save Receipts',
              subtitle: 'Keep digital copies of all payment receipts',
              value: _saveReceipts,
              onChanged: (value) => setState(() => _saveReceipts = value),
              iconName: 'receipt',
            ),

            _buildSettingsToggle(
              title: 'Email Receipts',
              subtitle: 'Send payment confirmations to your email',
              value: _emailReceipts,
              onChanged: (value) => setState(() => _emailReceipts = value),
              iconName: 'email',
            ),

            _buildSettingsToggle(
              title: 'Auto Payment',
              subtitle:
                  'Automatically charge default method for completed rides',
              value: _autoPayment,
              onChanged: (value) => setState(() => _autoPayment = value),
              iconName: 'auto_awesome',
            ),
          ],
        ),
      ),
    );
  }
}
