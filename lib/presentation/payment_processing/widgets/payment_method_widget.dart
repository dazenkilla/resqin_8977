import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentMethodWidget extends StatelessWidget {
  final Map<String, dynamic> method;
  final bool isSelected;
  final Function(String) onSelected;
  final Function(String, String) onCopyToClipboard;

  const PaymentMethodWidget({
    Key? key,
    required this.method,
    required this.isSelected,
    required this.onSelected,
    required this.onCopyToClipboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Method Header
          InkWell(
            onTap: () => onSelected(method['id']),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Radio<String>(
                    value: method['id'],
                    groupValue: isSelected ? method['id'] : '',
                    onChanged: (value) => onSelected(value ?? ''),
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: method['icon'] ?? 'payment',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          method['name'] ?? '',
                          style: AppTheme.lightTheme.textTheme.titleSmall,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          method['description'] ?? '',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Details
          if (isSelected) ...[
            Divider(
              color: AppTheme.lightTheme.dividerColor,
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: _buildMethodDetails(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMethodDetails() {
    if (method['id'] == 'bank_transfer') {
      return _buildBankTransferDetails();
    } else if (method['id'] == 'virtual_account') {
      return _buildVirtualAccountDetails();
    }
    return const SizedBox.shrink();
  }

  Widget _buildBankTransferDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Transfer Bank',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 2.h),

        // Bank Logos
        Text(
          'Bank yang Didukung:',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: (method['banks'] as List).map<Widget>((bank) {
            return Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: Text(
                bank['name'],
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 2.h),

        // Account Details
        _buildDetailRow(
          'Nomor Rekening',
          method['account_number'] ?? '',
          'Nomor Rekening',
          true,
        ),
        _buildDetailRow(
          'Nama Penerima',
          method['account_name'] ?? '',
          'Nama Penerima',
          false,
        ),
        _buildDetailRow(
          'Kode Referensi',
          method['reference'] ?? '',
          'Kode Referensi',
          true,
        ),
        SizedBox(height: 2.h),

        // Instructions
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Petunjuk Transfer',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                '1. Transfer sesuai nominal yang tertera\n'
                '2. Gunakan kode referensi sebagai berita transfer\n'
                '3. Simpan bukti transfer\n'
                '4. Upload bukti transfer di bawah ini',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVirtualAccountDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Virtual Account',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 2.h),

        // VA Number
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nomor Virtual Account',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      method['va_number'] ?? '',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => onCopyToClipboard(
                  method['va_number'] ?? '',
                  'Nomor Virtual Account',
                ),
                icon: CustomIconWidget(
                  iconName: 'content_copy',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),

        // Bank Options
        Text(
          'Pilih Bank:',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: (method['banks'] as List).map<Widget>((bank) {
            return Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: Text(
                bank['name'],
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 2.h),

        // Instructions
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Cara Pembayaran',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (method['instructions'] as List)
                    .asMap()
                    .entries
                    .map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 0.5.h),
                    child: Text(
                      '${entry.key + 1}. ${entry.value}',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
      String label, String value, String copyLabel, bool canCopy) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (canCopy)
            IconButton(
              onPressed: () => onCopyToClipboard(value, copyLabel),
              icon: CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
