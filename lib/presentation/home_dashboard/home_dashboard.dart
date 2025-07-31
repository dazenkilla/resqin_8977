import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/active_booking_banner_widget.dart';
import './widgets/ambulance_availability_widget.dart';
import './widgets/emergency_button_widget.dart';
import './widgets/location_card_widget.dart';
import './widgets/nearest_hospitals_widget.dart';
import './widgets/service_selection_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  bool _isRefreshing = false;
  bool _hasActiveBooking = false;

  // Mock data for current location
  final Map<String, dynamic> _currentLocation = {
    "address": "Jl. Sudirman No. 123, Menteng, Jakarta Pusat",
    "latitude": -6.2088,
    "longitude": 106.8456,
    "accuracy": "High"
  };

  // Mock data for ambulance availability
  final List<Map<String, dynamic>> _ambulanceData = [
    {
      "type": "APV",
      "available": 3,
      "eta": "5-8 min",
      "price": "Rp 150.000",
      "image":
          "https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=400"
    },
    {
      "type": "Alphard",
      "available": 2,
      "eta": "8-12 min",
      "price": "Rp 350.000",
      "image":
          "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400"
    },
    {
      "type": "H1",
      "available": 1,
      "eta": "10-15 min",
      "price": "Rp 250.000",
      "image": "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400"
    },
    {
      "type": "Hi-Ace",
      "available": 4,
      "eta": "6-10 min",
      "price": "Rp 200.000",
      "image": "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=400"
    }
  ];

  // Mock data for service types
  final List<Map<String, dynamic>> _serviceTypes = [
    {"name": "Within City", "priceRange": "Rp 150K - 300K", "isSelected": true},
    {
      "name": "Outside City",
      "priceRange": "Rp 400K - 800K",
      "isSelected": false
    },
    {
      "name": "Outside Province",
      "priceRange": "Rp 1M - 2.5M",
      "isSelected": false
    }
  ];

  // Mock data for nearest hospitals
  final List<Map<String, dynamic>> _nearestHospitals = [
    {
      "name": "RS Cipto Mangunkusumo",
      "distance": "1.2 km",
      "specialties": ["Emergency", "Cardiology", "Neurology"],
      "phone": "+62-21-3149208",
      "rating": 4.5,
      "image":
          "https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=400"
    },
    {
      "name": "RS Persahabatan",
      "distance": "2.8 km",
      "specialties": ["Pulmonology", "Emergency", "ICU"],
      "phone": "+62-21-4891708",
      "rating": 4.3,
      "image": "https://images.unsplash.com/photo-1551190822-a9333d879b1f?w=400"
    },
    {
      "name": "RS Premier Jatinegara",
      "distance": "3.5 km",
      "specialties": ["Emergency", "Orthopedic", "Pediatric"],
      "phone": "+62-21-2921888",
      "rating": 4.7,
      "image":
          "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400"
    }
  ];

  // Mock active booking data
  final Map<String, dynamic> _activeBooking = {
    "bookingId": "RSQ-2025071204",
    "driverName": "Ahmad Wijaya",
    "driverPhone": "+62-812-3456-7890",
    "vehicleType": "APV",
    "plateNumber": "B 1234 RSQ",
    "eta": "3 min",
    "status": "On the way"
  };

  @override
  void initState() {
    super.initState();
    // Simulate active booking for demo
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _hasActiveBooking = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _handleEmergencyPress() {
    Navigator.pushNamed(context, '/emergency-booking-flow');
  }

  void _handleLocationEdit() {
    // Handle location editing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location editing feature')),
    );
  }

  void _handleServiceSelection(int index) {
    setState(() {
      for (int i = 0; i < _serviceTypes.length; i++) {
        _serviceTypes[i]["isSelected"] = i == index;
      }
    });
  }

  void _handleHospitalCall(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phone')),
    );
  }

  void _handleActiveBookingTap() {
    Navigator.pushNamed(context, '/live-ambulance-tracking');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildStatusBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.lightTheme.primaryColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      if (_hasActiveBooking) ...[
                        ActiveBookingBannerWidget(
                          bookingData: _activeBooking,
                          onTap: _handleActiveBookingTap,
                        ),
                        SizedBox(height: 2.h),
                      ],
                      EmergencyButtonWidget(
                        onPressed: _handleEmergencyPress,
                      ),
                      SizedBox(height: 3.h),
                      LocationCardWidget(
                        locationData: _currentLocation,
                        onEditPressed: _handleLocationEdit,
                      ),
                      SizedBox(height: 3.h),
                      AmbulanceAvailabilityWidget(
                        ambulanceData: _ambulanceData,
                      ),
                      SizedBox(height: 3.h),
                      ServiceSelectionWidget(
                        serviceTypes: _serviceTypes,
                        onSelectionChanged: _handleServiceSelection,
                      ),
                      SizedBox(height: 3.h),
                      NearestHospitalsWidget(
                        hospitals: _nearestHospitals,
                        onCallPressed: _handleHospitalCall,
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ambulans.co',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                _currentLocation["accuracy"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            Navigator.pushNamed(context, '/emergency-booking-flow');
            break;
          case 2:
            Navigator.pushNamed(context, '/booking-history');
            break;
          case 3:
            Navigator.pushNamed(context, '/profile-settings-screen');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme.lightTheme.primaryColor,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'local_hospital',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Emergency',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'history',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
