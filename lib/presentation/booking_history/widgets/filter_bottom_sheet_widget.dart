import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final String selectedFilter;
  final Function(String) onFilterApplied;

  const FilterBottomSheetWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterApplied,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late String _tempSelectedFilter;
  DateTimeRange? _selectedDateRange;
  String _selectedServiceType = 'All';
  String _selectedPaymentStatus = 'All';
  String _selectedBookingPurpose = 'All';

  final List<String> _statusFilters = [
    'All',
    'Completed',
    'In Progress',
    'Cancelled',
  ];

  final List<String> _serviceTypes = [
    'All',
    'Within city',
    'Outside city',
    'Outside province',
  ];

  final List<String> _paymentStatuses = [
    'All',
    'Bank Transfer',
    'Virtual Account',
  ];

  final List<String> _bookingPurposes = [
    'All',
    'Emergency',
    'Referral',
    'Event/Escort',
    'Corpse transport',
  ];

  @override
  void initState() {
    super.initState();
    _tempSelectedFilter = widget.selectedFilter;
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      _tempSelectedFilter = 'All';
      _selectedDateRange = null;
      _selectedServiceType = 'All';
      _selectedPaymentStatus = 'All';
      _selectedBookingPurpose = 'All';
    });
  }

  void _applyFilters() {
    widget.onFilterApplied(_tempSelectedFilter);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Bookings',
                      style: AppTheme.lightTheme.textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: _clearAllFilters,
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                // Status Filter
                Text(
                  'Status',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: _statusFilters.map((status) {
                    final isSelected = _tempSelectedFilter == status;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _tempSelectedFilter = status;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        child: Text(
                          status,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 3.h),

                // Date Range Filter
                Text(
                  'Date Range',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: _selectDateRange,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'date_range',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            _selectedDateRange != null
                                ? '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}/${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}/${_selectedDateRange!.end.year}'
                                : 'Select date range',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: _selectedDateRange != null
                                  ? AppTheme.lightTheme.colorScheme.onSurface
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (_selectedDateRange != null)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDateRange = null;
                              });
                            },
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 3.h),

                // Service Type Filter
                Text(
                  'Service Type',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                _buildDropdownFilter(
                  value: _selectedServiceType,
                  items: _serviceTypes,
                  onChanged: (value) {
                    setState(() {
                      _selectedServiceType = value!;
                    });
                  },
                ),
                SizedBox(height: 2.h),

                // Payment Status Filter
                Text(
                  'Payment Method',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                _buildDropdownFilter(
                  value: _selectedPaymentStatus,
                  items: _paymentStatuses,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentStatus = value!;
                    });
                  },
                ),
                SizedBox(height: 2.h),

                // Booking Purpose Filter
                Text(
                  'Booking Purpose',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                _buildDropdownFilter(
                  value: _selectedBookingPurpose,
                  items: _bookingPurposes,
                  onChanged: (value) {
                    setState(() {
                      _selectedBookingPurpose = value!;
                    });
                  },
                ),
                SizedBox(height: 4.h),

                // Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
      ),
    );
  }
}
