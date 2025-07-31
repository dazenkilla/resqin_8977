import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_preferences_section_widget.dart';
import './widgets/emergency_features_section_widget.dart';
import './widgets/notification_preferences_section_widget.dart';
import './widgets/payment_settings_section_widget.dart';
import './widgets/personal_information_section_widget.dart';
import './widgets/privacy_controls_section_widget.dart';
import './widgets/profile_header_widget.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "Dr. Sarah Johnson",
    "email": "sarah.johnson@gmail.com",
    "phone": "+62-812-3456-7890",
    "emergencyId": "RSQ-EMR-001234",
    "profileImage":
        "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200",
    "bloodType": "O+",
    "allergies": ["Penicillin", "Shellfish"],
    "medicalConditions": ["Diabetes Type 2"],
    "emergencyContacts": [
      {
        "name": "John Johnson",
        "relationship": "Spouse",
        "phone": "+62-813-7654-3210"
      },
      {
        "name": "Emma Johnson",
        "relationship": "Daughter",
        "phone": "+62-814-9876-5432"
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.index = 3; // Profile tab active as specified
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleDataSync() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network sync
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings synchronized successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout Confirmation',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to logout from your account?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/google-login-screen',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _handleHelpSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening help documentation...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingIndicator()
                  : SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Column(
                        children: [
                          ProfileHeaderWidget(userData: _userData),
                          SizedBox(height: 3.h),
                          PersonalInformationSectionWidget(userData: _userData),
                          SizedBox(height: 2.h),
                          const NotificationPreferencesSectionWidget(),
                          SizedBox(height: 2.h),
                          const PaymentSettingsSectionWidget(),
                          SizedBox(height: 2.h),
                          const PrivacyControlsSectionWidget(),
                          SizedBox(height: 2.h),
                          const EmergencyFeaturesSectionWidget(),
                          SizedBox(height: 2.h),
                          const AppPreferencesSectionWidget(),
                          SizedBox(height: 3.h),
                          _buildActionButtons(),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
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
        children: [
          CustomIconWidget(
            iconName: 'arrow_back',
            size: 24,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          SizedBox(width: 3.w),
          Text(
            'Profile Settings',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _handleDataSync,
            icon: CustomIconWidget(
              iconName: 'sync',
              size: 24,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: const [
          Tab(text: 'Home'),
          Tab(text: 'Emergency'),
          Tab(text: 'History'),
          Tab(text: 'Profile'),
          Tab(text: 'Help'),
          Tab(text: 'About'),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
          SizedBox(height: 2.h),
          Text(
            'Synchronizing settings...',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Help & Support Button
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 2.h),
          child: OutlinedButton.icon(
            onPressed: _handleHelpSupport,
            icon: CustomIconWidget(
              iconName: 'help_outline',
              size: 20,
              color: AppTheme.lightTheme.primaryColor,
            ),
            label: const Text('Help & Support'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
          ),
        ),
        // Logout Button
        Container(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _handleLogout,
            icon: CustomIconWidget(
              iconName: 'logout',
              size: 20,
              color: Colors.white,
            ),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 3, // Profile tab active
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home-dashboard');
            break;
          case 1:
            Navigator.pushNamed(context, '/emergency-booking-flow');
            break;
          case 2:
            Navigator.pushNamed(context, '/booking-history');
            break;
          case 3:
            // Already on profile settings
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
            color: AppTheme.lightTheme.primaryColor,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
