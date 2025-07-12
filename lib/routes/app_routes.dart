import 'package:flutter/material.dart';
import '../presentation/google_login_screen/google_login_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/booking_history/booking_history.dart';
import '../presentation/payment_processing/payment_processing.dart';
import '../presentation/live_ambulance_tracking/live_ambulance_tracking.dart';
import '../presentation/emergency_booking_flow/emergency_booking_flow.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String googleLoginScreen = '/google-login-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String bookingHistory = '/booking-history';
  static const String paymentProcessing = '/payment-processing';
  static const String liveAmbulanceTracking = '/live-ambulance-tracking';
  static const String emergencyBookingFlow = '/emergency-booking-flow';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => GoogleLoginScreen(),
    googleLoginScreen: (context) => GoogleLoginScreen(),
    homeDashboard: (context) => HomeDashboard(),
    bookingHistory: (context) => BookingHistory(),
    paymentProcessing: (context) => PaymentProcessing(),
    liveAmbulanceTracking: (context) => LiveAmbulanceTracking(),
    emergencyBookingFlow: (context) => EmergencyBookingFlow(),
    // TODO: Add your other routes here
  };
}
