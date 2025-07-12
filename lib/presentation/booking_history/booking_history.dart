import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isSearching = false;
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _filteredBookings = [];

  final List<Map<String, dynamic>> _mockBookings = [
    {
      "id": "RSQ001",
      "date": "2025-01-12",
      "time": "14:30",
      "pickupLocation": "Jl. Sudirman No. 45, Jakarta Pusat",
      "destinationLocation": "RS Cipto Mangunkusumo, Jl. Diponegoro No. 71",
      "ambulanceType": "APV",
      "totalFare": "Rp 350.000",
      "status": "Completed",
      "driverName": "Ahmad Wijaya",
      "driverPhone": "+62 812-3456-7890",
      "bookingPurpose": "Emergency",
      "serviceType": "Within city",
      "patientCondition": "Stable condition, chest pain",
      "paymentMethod": "Bank Transfer",
      "duration": "45 minutes",
      "distance": "12.5 km"
    },
    {
      "id": "RSQ002",
      "date": "2025-01-10",
      "time": "09:15",
      "pickupLocation": "Jl. Thamrin No. 28, Jakarta Pusat",
      "destinationLocation": "RS Persahabatan, Jl. Persahabatan Raya No. 1",
      "ambulanceType": "Alphard",
      "totalFare": "Rp 500.000",
      "status": "Completed",
      "driverName": "Budi Santoso",
      "driverPhone": "+62 813-9876-5432",
      "bookingPurpose": "Referral",
      "serviceType": "Within city",
      "patientCondition": "Critical condition, requires ICU",
      "paymentMethod": "Virtual Account",
      "duration": "35 minutes",
      "distance": "8.2 km"
    },
    {
      "id": "RSQ003",
      "date": "2025-01-08",
      "time": "16:45",
      "pickupLocation": "Jl. Gatot Subroto No. 15, Jakarta Selatan",
      "destinationLocation": "RS Fatmawati, Jl. RS Fatmawati Raya No. 80",
      "ambulanceType": "Hyundai H1",
      "totalFare": "Rp 425.000",
      "status": "Cancelled",
      "driverName": "Sari Indah",
      "driverPhone": "+62 814-5678-9012",
      "bookingPurpose": "Event/Escort",
      "serviceType": "Within city",
      "patientCondition": "Routine check-up transport",
      "paymentMethod": "Bank Transfer",
      "duration": "0 minutes",
      "distance": "0 km"
    },
    {
      "id": "RSQ004",
      "date": "2025-01-05",
      "time": "11:20",
      "pickupLocation": "Jl. Kemang Raya No. 67, Jakarta Selatan",
      "destinationLocation": "RS Pondok Indah, Jl. Metro Duta Kav. UE",
      "ambulanceType": "Hi-Ace",
      "totalFare": "Rp 380.000",
      "status": "Completed",
      "driverName": "Eko Prasetyo",
      "driverPhone": "+62 815-2468-1357",
      "bookingPurpose": "Emergency",
      "serviceType": "Within city",
      "patientCondition": "Accident victim, multiple injuries",
      "paymentMethod": "Virtual Account",
      "duration": "28 minutes",
      "distance": "6.8 km"
    },
    {
      "id": "RSQ005",
      "date": "2025-01-03",
      "time": "08:00",
      "pickupLocation": "Jl. Casablanca Raya No. 88, Jakarta Selatan",
      "destinationLocation": "RS Premier Jatinegara, Jl. Raya Jatinegara Timur",
      "ambulanceType": "APV",
      "totalFare": "Rp 320.000",
      "status": "In Progress",
      "driverName": "Dewi Sartika",
      "driverPhone": "+62 816-7890-1234",
      "bookingPurpose": "Referral",
      "serviceType": "Within city",
      "patientCondition": "Elderly patient, routine transfer",
      "paymentMethod": "Bank Transfer",
      "duration": "Ongoing",
      "distance": "15.2 km"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredBookings = List.from(_mockBookings);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterBookings(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBookings = List.from(_mockBookings);
      } else {
        _filteredBookings = _mockBookings.where((booking) {
          final searchLower = query.toLowerCase();
          return (booking["id"] as String)
                  .toLowerCase()
                  .contains(searchLower) ||
              (booking["pickupLocation"] as String)
                  .toLowerCase()
                  .contains(searchLower) ||
              (booking["destinationLocation"] as String)
                  .toLowerCase()
                  .contains(searchLower) ||
              (booking["status"] as String).toLowerCase().contains(searchLower);
        }).toList();
      }
    });
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      if (filter == 'All') {
        _filteredBookings = List.from(_mockBookings);
      } else {
        _filteredBookings = _mockBookings
            .where((booking) => (booking["status"] as String) == filter)
            .toList();
      }
    });
  }

  Future<void> _refreshBookings() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _filteredBookings = List.from(_mockBookings);
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedFilter: _selectedFilter,
        onFilterApplied: _applyFilter,
      ),
    );
  }

  void _navigateToBookingDetail(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => _buildBookingDetailDialog(booking),
    );
  }

  Widget _buildBookingDetailDialog(Map<String, dynamic> booking) {
    return Dialog(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 80.h),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking Details',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Booking ID', booking["id"] as String),
                    _buildDetailRow('Date & Time',
                        '${booking["date"]} at ${booking["time"]}'),
                    _buildDetailRow('Status', booking["status"] as String),
                    _buildDetailRow(
                        'Service Type', booking["serviceType"] as String),
                    _buildDetailRow(
                        'Booking Purpose', booking["bookingPurpose"] as String),
                    SizedBox(height: 2.h),
                    Text(
                      'Route Information',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    _buildDetailRow(
                        'Pickup Location', booking["pickupLocation"] as String),
                    _buildDetailRow('Destination',
                        booking["destinationLocation"] as String),
                    _buildDetailRow('Distance', booking["distance"] as String),
                    _buildDetailRow('Duration', booking["duration"] as String),
                    SizedBox(height: 2.h),
                    Text(
                      'Vehicle & Driver',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    _buildDetailRow(
                        'Ambulance Type', booking["ambulanceType"] as String),
                    _buildDetailRow(
                        'Driver Name', booking["driverName"] as String),
                    _buildDetailRow(
                        'Driver Phone', booking["driverPhone"] as String),
                    SizedBox(height: 2.h),
                    Text(
                      'Payment Information',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    _buildDetailRow(
                        'Total Fare', booking["totalFare"] as String),
                    _buildDetailRow(
                        'Payment Method', booking["paymentMethod"] as String),
                    _buildDetailRow('Patient Condition',
                        booking["patientCondition"] as String),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Download receipt functionality
                    },
                    child: Text('Download Receipt'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/emergency-booking-flow');
                    },
                    child: Text('Book Again'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(': ', style: AppTheme.lightTheme.textTheme.bodyMedium),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search bookings...',
                  border: InputBorder.none,
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                onChanged: _filterBookings,
              )
            : Text(
                'Booking History',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filterBookings('');
                }
              });
            },
            icon: CustomIconWidget(
              iconName: _isSearching ? 'close' : 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'History'),
            Tab(text: 'Ongoing'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_selectedFilter != 'All')
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'filter_alt',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Filtered by: $_selectedFilter',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _applyFilter('All'),
                    child: Text(
                      'Clear',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList(_filteredBookings),
                _buildBookingList(_filteredBookings
                    .where((booking) =>
                        (booking["status"] as String) == "Completed" ||
                        (booking["status"] as String) == "Cancelled")
                    .toList()),
                _buildBookingList(_filteredBookings
                    .where((booking) =>
                        (booking["status"] as String) == "In Progress")
                    .toList()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, '/emergency-booking-flow'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildBookingList(List<Map<String, dynamic>> bookings) {
    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshBookings,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(4.w),
        itemCount: bookings.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == bookings.length && _isLoading) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            );
          }

          final booking = bookings[index];
          return BookingCardWidget(
            booking: booking,
            onTap: () => _navigateToBookingDetail(booking),
            onSwipeLeft: () {
              // Download receipt action
            },
            onSwipeRight: () {
              Navigator.pushNamed(context, '/emergency-booking-flow');
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 80,
          ),
          SizedBox(height: 2.h),
          Text(
            'No bookings yet',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your booking history will appear here',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/emergency-booking-flow'),
            child: Text('Book Now'),
          ),
        ],
      ),
    );
  }
}
