import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DestinationSelectionWidget extends StatefulWidget {
  final Function(Map<String, double>, String) onDestinationSelected;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final String initialAddress;

  const DestinationSelectionWidget({
    Key? key,
    required this.onDestinationSelected,
    required this.onNext,
    required this.onBack,
    required this.initialAddress,
  }) : super(key: key);

  @override
  State<DestinationSelectionWidget> createState() =>
      _DestinationSelectionWidgetState();
}

class _DestinationSelectionWidgetState
    extends State<DestinationSelectionWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDestination = '';
  Map<String, double> _selectedLocation = {'lat': -6.2088, 'lng': 106.8456};
  bool _showCustomInput = false;

  final List<Map<String, dynamic>> nearbyHospitals = [
    {
      'name': 'RS Cipto Mangunkusumo',
      'address': 'Jl. Diponegoro No. 71, Jakarta Pusat',
      'distance': '2.3 km',
      'specialties': ['Emergency', 'Trauma', 'ICU'],
      'rating': 4.5,
      'image':
          'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
    },
    {
      'name': 'RS Persahabatan',
      'address': 'Jl. Persahabatan Raya No. 1, Jakarta Timur',
      'distance': '4.1 km',
      'specialties': ['Respiratory', 'Emergency', 'Internal Medicine'],
      'rating': 4.3,
      'image':
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
    },
    {
      'name': 'RS Premier Jatinegara',
      'address': 'Jl. Raya Jatinegara Timur No. 85-87',
      'distance': '5.2 km',
      'specialties': ['Emergency', 'Cardiology', 'Neurology'],
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1551190822-a9333d879b1f?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress.isNotEmpty) {
      _selectedDestination = widget.initialAddress;
      _searchController.text = widget.initialAddress;
    }
  }

  void _selectHospital(Map<String, dynamic> hospital) {
    setState(() {
      _selectedDestination = '${hospital['name']} - ${hospital['address']}';
      _showCustomInput = false;
    });
    widget.onDestinationSelected(_selectedLocation, _selectedDestination);
  }

  void _selectCustomDestination(String address) {
    setState(() {
      _selectedDestination = address;
    });
    widget.onDestinationSelected(_selectedLocation, address);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Destination',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose a hospital or enter a custom destination address.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Search bar
          TextField(
            controller: _searchController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _showCustomInput = true;
                });
                _selectCustomDestination(value);
              }
            },
            decoration: InputDecoration(
              hintText: 'Search hospitals or enter address...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _showCustomInput = false;
                          _selectedDestination = '';
                        });
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    )
                  : null,
            ),
          ),

          SizedBox(height: 3.h),

          // Nearby hospitals section
          if (!_showCustomInput) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_hospital',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Nearby Hospitals',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            ...nearbyHospitals.map((hospital) => _buildHospitalCard(hospital)),

            SizedBox(height: 3.h),

            // Custom destination option
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Custom Destination',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Enter any address or location',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _showCustomInput = true;
                      });
                      _searchController.clear();
                    },
                    child: Text('Enter Custom Address'),
                  ),
                ],
              ),
            ),
          ],

          // Custom input confirmation
          if (_showCustomInput && _searchController.text.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Selected Destination',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _searchController.text,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

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
                  onPressed:
                      _selectedDestination.isNotEmpty ? widget.onNext : null,
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

  Widget _buildHospitalCard(Map<String, dynamic> hospital) {
    final bool isSelected = _selectedDestination.contains(hospital['name']);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () => _selectHospital(hospital),
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: hospital['image'],
                  width: 20.w,
                  height: 15.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital['name'],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      hospital['address'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          hospital['distance'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        CustomIconWidget(
                          iconName: 'star',
                          color: Colors.amber,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          hospital['rating'].toString(),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 1.w,
                      children: (hospital['specialties'] as List<String>)
                          .take(2)
                          .map((specialty) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            specialty,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
