import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceDetailsWidget extends StatefulWidget {
  final Function(String, String, String) onServiceSelected;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final String initialServiceType;
  final String initialAmbulanceType;
  final String initialPurpose;

  const ServiceDetailsWidget({
    Key? key,
    required this.onServiceSelected,
    required this.onNext,
    required this.onBack,
    required this.initialServiceType,
    required this.initialAmbulanceType,
    required this.initialPurpose,
  }) : super(key: key);

  @override
  State<ServiceDetailsWidget> createState() => _ServiceDetailsWidgetState();
}

class _ServiceDetailsWidgetState extends State<ServiceDetailsWidget> {
  String _selectedServiceType = 'Within City';
  String _selectedAmbulanceType = 'APV';
  String _selectedPurpose = 'Emergency';

  final List<Map<String, dynamic>> serviceTypes = [
    {
      'type': 'Within City',
      'description': 'Local city transport',
      'baseFare': 150000,
      'icon': 'location_city',
    },
    {
      'type': 'Outside City',
      'description': 'Inter-city transport',
      'baseFare': 300000,
      'icon': 'directions_car',
    },
    {
      'type': 'Outside Province',
      'description': 'Inter-province transport',
      'baseFare': 500000,
      'icon': 'flight_takeoff',
    },
  ];

  final List<Map<String, dynamic>> ambulanceTypes = [
    {
      'type': 'APV',
      'description': 'Basic ambulance vehicle',
      'capacity': '2 patients',
      'features': ['Basic life support', 'Oxygen supply', 'First aid kit'],
      'image':
          'https://images.unsplash.com/photo-1582750433449-648ed127bb54?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
    },
    {
      'type': 'Alphard',
      'description': 'Premium ambulance',
      'capacity': '1 patient + family',
      'features': [
        'Advanced life support',
        'ICU equipment',
        'Comfortable seating'
      ],
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
    },
    {
      'type': 'Hyundai H1',
      'description': 'Standard ambulance',
      'capacity': '2 patients',
      'features': [
        'Intermediate life support',
        'Stretcher',
        'Medical equipment'
      ],
      'image':
          'https://images.unsplash.com/photo-1563013544-824ae1b704d3?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
    },
    {
      'type': 'Hi-Ace',
      'description': 'Multi-patient transport',
      'capacity': '4 patients',
      'features': ['Multiple stretchers', 'Basic monitoring', 'Large capacity'],
      'image':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
    },
  ];

  final List<Map<String, dynamic>> bookingPurposes = [
    {
      'purpose': 'Emergency',
      'description': 'Critical medical emergency',
      'priority': 'High',
      'icon': 'emergency',
      'color': Colors.red,
    },
    {
      'purpose': 'Referral',
      'description': 'Hospital to hospital transfer',
      'priority': 'Medium',
      'icon': 'local_hospital',
      'color': Colors.blue,
    },
    {
      'purpose': 'Event/Escort',
      'description': 'Medical standby for events',
      'priority': 'Low',
      'icon': 'event',
      'color': Colors.green,
    },
    {
      'purpose': 'Corpse Transport',
      'description': 'Deceased transport service',
      'priority': 'Standard',
      'icon': 'sentiment_very_dissatisfied',
      'color': Colors.grey,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedServiceType = widget.initialServiceType;
    _selectedAmbulanceType = widget.initialAmbulanceType;
    _selectedPurpose = widget.initialPurpose;
  }

  void _updateSelection() {
    widget.onServiceSelected(
        _selectedServiceType, _selectedAmbulanceType, _selectedPurpose);
  }

  double _calculateEstimatedFare() {
    final serviceType =
        serviceTypes.firstWhere((type) => type['type'] == _selectedServiceType);
    double baseFare = serviceType['baseFare'].toDouble();

    // Add ambulance type multiplier
    switch (_selectedAmbulanceType) {
      case 'Alphard':
        baseFare *= 1.5;
        break;
      case 'Hyundai H1':
        baseFare *= 1.2;
        break;
      case 'Hi-Ace':
        baseFare *= 1.3;
        break;
    }

    // Add purpose multiplier
    if (_selectedPurpose == 'Emergency') {
      baseFare *= 1.2;
    }

    return baseFare;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Details',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Select service type, ambulance vehicle, and booking purpose.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Service Type Selection
          _buildSectionHeader('Service Type', 'location_city'),
          SizedBox(height: 2.h),
          _buildServiceTypeSelector(),

          SizedBox(height: 3.h),

          // Ambulance Type Selection
          _buildSectionHeader('Ambulance Type', 'local_shipping'),
          SizedBox(height: 2.h),
          _buildAmbulanceTypeSelector(),

          SizedBox(height: 3.h),

          // Booking Purpose Selection
          _buildSectionHeader('Booking Purpose', 'assignment'),
          SizedBox(height: 2.h),
          _buildBookingPurposeSelector(),

          SizedBox(height: 3.h),

          // Estimated Fare
          _buildEstimatedFare(),

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
                  onPressed: () {
                    _updateSelection();
                    widget.onNext();
                  },
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

  Widget _buildServiceTypeSelector() {
    return Column(
      children: serviceTypes.map((service) {
        final bool isSelected = _selectedServiceType == service['type'];
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedServiceType = service['type'];
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
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: service['icon'],
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['type'],
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : null,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          service['description'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'From',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Rp ${(service['baseFare'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : null,
                        ),
                      ),
                    ],
                  ),
                  if (isSelected) ...[
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAmbulanceTypeSelector() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 0.8,
      ),
      itemCount: ambulanceTypes.length,
      itemBuilder: (context, index) {
        final ambulance = ambulanceTypes[index];
        final bool isSelected = _selectedAmbulanceType == ambulance['type'];

        return InkWell(
          onTap: () {
            setState(() {
              _selectedAmbulanceType = ambulance['type'];
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(3.w),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: ambulance['image'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 2.w),
                Text(
                  ambulance['type'],
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : null,
                  ),
                ),
                SizedBox(height: 1.w),
                Text(
                  ambulance['description'],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.w),
                Text(
                  ambulance['capacity'],
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isSelected)
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingPurposeSelector() {
    return Column(
      children: bookingPurposes.map((purpose) {
        final bool isSelected = _selectedPurpose == purpose['purpose'];
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedPurpose = purpose['purpose'];
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
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : (purpose['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: purpose['icon'],
                      color:
                          isSelected ? Colors.white : purpose['color'] as Color,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          purpose['purpose'],
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : null,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          purpose['description'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: (purpose['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      purpose['priority'],
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: purpose['color'] as Color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isSelected) ...[
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEstimatedFare() {
    final estimatedFare = _calculateEstimatedFare();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'attach_money',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Estimated Fare',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Rp ${estimatedFare.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.tertiary,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Final fare may vary based on distance and additional services',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
