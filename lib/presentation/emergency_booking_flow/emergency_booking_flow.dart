import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_confirmation_widget.dart';
import './widgets/destination_selection_widget.dart';
import './widgets/patient_information_widget.dart';
import './widgets/pickup_location_widget.dart';
import './widgets/service_details_widget.dart';

class EmergencyBookingFlow extends StatefulWidget {
  const EmergencyBookingFlow({Key? key}) : super(key: key);

  @override
  State<EmergencyBookingFlow> createState() => _EmergencyBookingFlowState();
}

class _EmergencyBookingFlowState extends State<EmergencyBookingFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Booking data storage
  Map<String, dynamic> bookingData = {
    'pickupLocation': null,
    'pickupAddress': '',
    'destinationLocation': null,
    'destinationAddress': '',
    'serviceType': 'Within City',
    'ambulanceType': 'APV',
    'bookingPurpose': 'Emergency',
    'patientCondition': '',
    'emergencyContact': null,
    'estimatedFare': 150000.0,
  };

  final List<String> stepTitles = [
    'Pickup Location',
    'Destination',
    'Service Details',
    'Patient Info',
    'Confirmation'
  ];

  @override
  void initState() {
    super.initState();
    // Trigger haptic feedback for emergency flow
    HapticFeedback.heavyImpact();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      HapticFeedback.selectionClick();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      HapticFeedback.selectionClick();
    }
  }

  void _updateBookingData(String key, dynamic value) {
    setState(() {
      bookingData[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildEmergencyAppBar(),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PickupLocationWidget(
                  onLocationSelected: (location, address) {
                    _updateBookingData('pickupLocation', location);
                    _updateBookingData('pickupAddress', address);
                  },
                  onNext: _nextStep,
                  initialAddress: bookingData['pickupAddress'] ?? '',
                ),
                DestinationSelectionWidget(
                  onDestinationSelected: (location, address) {
                    _updateBookingData('destinationLocation', location);
                    _updateBookingData('destinationAddress', address);
                  },
                  onNext: _nextStep,
                  onBack: _previousStep,
                  initialAddress: bookingData['destinationAddress'] ?? '',
                ),
                ServiceDetailsWidget(
                  onServiceSelected: (serviceType, ambulanceType, purpose) {
                    _updateBookingData('serviceType', serviceType);
                    _updateBookingData('ambulanceType', ambulanceType);
                    _updateBookingData('bookingPurpose', purpose);
                  },
                  onNext: _nextStep,
                  onBack: _previousStep,
                  initialServiceType:
                      bookingData['serviceType'] ?? 'Within City',
                  initialAmbulanceType: bookingData['ambulanceType'] ?? 'APV',
                  initialPurpose: bookingData['bookingPurpose'] ?? 'Emergency',
                ),
                PatientInformationWidget(
                  onPatientInfoSubmitted: (condition, contact) {
                    _updateBookingData('patientCondition', condition);
                    _updateBookingData('emergencyContact', contact);
                  },
                  onNext: _nextStep,
                  onBack: _previousStep,
                  initialCondition: bookingData['patientCondition'] ?? '',
                  initialContact: bookingData['emergencyContact'],
                ),
                BookingConfirmationWidget(
                  bookingData: bookingData,
                  onConfirmBooking: _confirmEmergencyBooking,
                  onBack: _previousStep,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildEmergencyAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: _currentStep > 0
          ? IconButton(
              onPressed: _previousStep,
              icon: CustomIconWidget(
                iconName: 'arrow_back',
                color: Colors.white,
                size: 24,
              ),
            )
          : IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'close',
                color: Colors.white,
                size: 24,
              ),
            ),
      title: Text(
        'Emergency Booking',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 4.w),
          child: CustomIconWidget(
            iconName: 'local_hospital',
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Column(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index <= _currentStep
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                        ),
                        child: index < _currentStep
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 16,
                              )
                            : Center(
                                child: Text(
                                  '${index + 1}',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: index == _currentStep
                                        ? Colors.white
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        stepTitles[index],
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: index <= _currentStep
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: index == _currentStep
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: (_currentStep + 1) / 5,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  void _confirmEmergencyBooking() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                'Finding nearest ambulance...',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

      // Simulate booking process
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            icon: CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 48,
            ),
            title: Text(
              'Booking Confirmed!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your emergency ambulance has been dispatched.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Booking ID: EMG-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                        style: AppTheme.dataTextTheme(isLight: true).bodyMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'ETA: 8-12 minutes',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close success dialog
                  Navigator.pushReplacementNamed(
                      context, '/live-ambulance-tracking');
                },
                child: Text('Track Ambulance'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close success dialog
                  Navigator.pushReplacementNamed(context, '/home-dashboard');
                },
                child: Text('Go to Dashboard'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: CustomIconWidget(
              iconName: 'error',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 48,
            ),
            title: Text(
              'Booking Failed',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
            content: Text(
              'Unable to find available ambulances. Please try again or call emergency services directly.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Try Again'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Open phone dialer for emergency number
                },
                child: Text('Call 119'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
