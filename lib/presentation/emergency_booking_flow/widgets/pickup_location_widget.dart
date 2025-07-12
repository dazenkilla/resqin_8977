import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PickupLocationWidget extends StatefulWidget {
  final Function(Map<String, double>, String) onLocationSelected;
  final VoidCallback onNext;
  final String initialAddress;

  const PickupLocationWidget({
    Key? key,
    required this.onLocationSelected,
    required this.onNext,
    required this.initialAddress,
  }) : super(key: key);

  @override
  State<PickupLocationWidget> createState() => _PickupLocationWidgetState();
}

class _PickupLocationWidgetState extends State<PickupLocationWidget> {
  final TextEditingController _addressController = TextEditingController();
  bool _isLoadingLocation = false;
  Map<String, double> _currentLocation = {
    'lat': -6.2088,
    'lng': 106.8456
  }; // Jakarta default
  String _currentAddress = '';

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.initialAddress;
    if (widget.initialAddress.isEmpty) {
      _getCurrentLocation();
    } else {
      _currentAddress = widget.initialAddress;
    }
  }

  void _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    // Simulate GPS location fetch
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _currentLocation = {'lat': -6.2088, 'lng': 106.8456};
      _currentAddress = 'Jl. Sudirman No. 1, Jakarta Pusat, DKI Jakarta';
      _addressController.text = _currentAddress;
      _isLoadingLocation = false;
    });

    widget.onLocationSelected(_currentLocation, _currentAddress);
  }

  void _searchLocation(String query) {
    if (query.isNotEmpty) {
      // Simulate location search
      setState(() {
        _currentAddress = query;
      });
      widget.onLocationSelected(_currentLocation, query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirm Pickup Location',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Please confirm or adjust your pickup location for the ambulance.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Map Container
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Mock map background
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.green.shade100,
                          Colors.blue.shade100,
                        ],
                      ),
                    ),
                    child: CustomImageWidget(
                      imageUrl:
                          'https://images.unsplash.com/photo-1524661135-423995f22d0b?fm=jpg&q=60&w=800&ixlib=rb-4.0.3',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Map overlay with grid pattern
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),

                  // Center pin
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 40,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: AppTheme.cardShadow,
                          ),
                          child: Text(
                            'Pickup Location',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Current location button
                  Positioned(
                    top: 2.h,
                    right: 4.w,
                    child: FloatingActionButton.small(
                      onPressed:
                          _isLoadingLocation ? null : _getCurrentLocation,
                      backgroundColor: Colors.white,
                      child: _isLoadingLocation
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            )
                          : CustomIconWidget(
                              iconName: 'my_location',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Address search field
          Text(
            'Search or Enter Address',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),

          TextField(
            controller: _addressController,
            onChanged: _searchLocation,
            decoration: InputDecoration(
              hintText: 'Enter pickup address...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: _addressController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _addressController.clear();
                        _searchLocation('');
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

          SizedBox(height: 2.h),

          // Quick location suggestions
          if (_addressController.text.isEmpty) ...[
            Text(
              'Quick Suggestions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            ..._buildLocationSuggestions(),
          ],

          SizedBox(height: 4.h),

          // Confirm button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _currentAddress.isNotEmpty ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text(
                'Confirm Pickup Location',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLocationSuggestions() {
    final suggestions = [
      {
        'title': 'Current Location',
        'subtitle': 'Use GPS location',
        'icon': 'my_location',
      },
      {
        'title': 'Home',
        'subtitle': 'Jl. Kebon Jeruk No. 15',
        'icon': 'home',
      },
      {
        'title': 'Office',
        'subtitle': 'Jl. Thamrin No. 28',
        'icon': 'business',
      },
    ];

    return suggestions.map((suggestion) {
      return Container(
        margin: EdgeInsets.only(bottom: 1.h),
        child: ListTile(
          onTap: () {
            _addressController.text = suggestion['subtitle']!;
            _searchLocation(suggestion['subtitle']!);
          },
          leading: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: suggestion['icon']!,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            suggestion['title']!,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            suggestion['subtitle']!,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: CustomIconWidget(
            iconName: 'arrow_forward_ios',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}
