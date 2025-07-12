import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/payment_method_widget.dart';
import './widgets/payment_timer_widget.dart';
import './widgets/receipt_upload_widget.dart';
import './widgets/service_breakdown_widget.dart';

class PaymentProcessing extends StatefulWidget {
  const PaymentProcessing({Key? key}) : super(key: key);

  @override
  State<PaymentProcessing> createState() => _PaymentProcessingState();
}

class _PaymentProcessingState extends State<PaymentProcessing>
    with TickerProviderStateMixin {
  String selectedPaymentMethod = 'bank_transfer';
  bool isProcessing = false;
  bool paymentCompleted = false;
  String? uploadedReceiptPath;
  Timer? paymentTimer;
  Duration remainingTime = const Duration(hours: 24);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock booking data
  final Map<String, dynamic> bookingData = {
    "booking_id": "RSQ-240712-001",
    "service_type": "Emergency",
    "vehicle_type": "Alphard",
    "pickup_location": "Jl. Sudirman No. 123, Jakarta Pusat",
    "destination": "RS Cipto Mangunkusumo, Jakarta Pusat",
    "distance": "12.5 km",
    "duration": "45 menit",
    "base_fare": 150000,
    "distance_charge": 75000,
    "time_charge": 25000,
    "total_amount": 250000,
    "payment_deadline": DateTime.now().add(const Duration(hours: 24)),
  };

  final List<Map<String, dynamic>> paymentMethods = [
    {
      "id": "bank_transfer",
      "name": "Bank Transfer",
      "description": "Transfer ke rekening bank",
      "icon": "account_balance",
      "banks": [
        {
          "name": "BCA",
          "logo":
              "https://logos-world.net/wp-content/uploads/2020/12/BCA-Logo.png"
        },
        {
          "name": "Mandiri",
          "logo":
              "https://logos-world.net/wp-content/uploads/2020/12/Bank-Mandiri-Logo.png"
        },
        {
          "name": "BNI",
          "logo":
              "https://logos-world.net/wp-content/uploads/2020/12/BNI-Logo.png"
        },
      ],
      "account_number": "1234567890",
      "account_name": "PT ResQin Indonesia",
      "reference": "RSQ240712001",
    },
    {
      "id": "virtual_account",
      "name": "Virtual Account",
      "description": "Bayar melalui ATM/Mobile Banking",
      "icon": "credit_card",
      "banks": [
        {
          "name": "BCA",
          "logo":
              "https://logos-world.net/wp-content/uploads/2020/12/BCA-Logo.png"
        },
        {
          "name": "Mandiri",
          "logo":
              "https://logos-world.net/wp-content/uploads/2020/12/Bank-Mandiri-Logo.png"
        },
        {
          "name": "BRI",
          "logo":
              "https://logos-world.net/wp-content/uploads/2020/12/BRI-Logo.png"
        },
      ],
      "va_number": "8808240712001234",
      "instructions": [
        "Masuk ke ATM atau Mobile Banking",
        "Pilih menu Transfer/Bayar",
        "Masukkan nomor Virtual Account",
        "Konfirmasi pembayaran",
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startPaymentTimer();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  void _startPaymentTimer() {
    paymentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        _handlePaymentExpired();
      }
    });
  }

  void _handlePaymentExpired() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Waktu Pembayaran Habis',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Waktu pembayaran telah habis. Silakan buat kode pembayaran baru.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _generateNewPaymentCode();
            },
            child: const Text('Buat Kode Baru'),
          ),
        ],
      ),
    );
  }

  void _generateNewPaymentCode() {
    setState(() {
      remainingTime = const Duration(hours: 24);
      // Generate new payment codes
      final selectedMethod = paymentMethods.firstWhere(
        (method) => method['id'] == selectedPaymentMethod,
      );
      if (selectedPaymentMethod == 'virtual_account') {
        selectedMethod['va_number'] =
            '8808${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      } else {
        selectedMethod['reference'] =
            'RSQ${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      }
    });
    _startPaymentTimer();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil disalin'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _processPayment() async {
    if (uploadedReceiptPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan upload bukti pembayaran terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isProcessing = false;
      paymentCompleted = true;
    });

    paymentTimer?.cancel();
    _showPaymentSuccess();
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'Pembayaran Berhasil!',
              style: AppTheme.lightTheme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Pembayaran Anda sedang diverifikasi. Anda akan menerima konfirmasi melalui SMS dan email.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/home-dashboard');
              },
              child: const Text('Kembali ke Beranda'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    paymentTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Pembayaran',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: isProcessing ? _buildProcessingView() : _buildPaymentView(),
      ),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 3.h),
          Text(
            'Memproses Pembayaran...',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Mohon tunggu sebentar',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment Timer
          PaymentTimerWidget(
            remainingTime: remainingTime,
            onExpired: _handlePaymentExpired,
          ),
          SizedBox(height: 3.h),

          // Service Breakdown
          ServiceBreakdownWidget(bookingData: bookingData),
          SizedBox(height: 3.h),

          // Payment Method Selection
          Text(
            'Pilih Metode Pembayaran',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          ...paymentMethods.map((method) => PaymentMethodWidget(
                method: method,
                isSelected: selectedPaymentMethod == method['id'],
                onSelected: (methodId) {
                  setState(() {
                    selectedPaymentMethod = methodId;
                  });
                },
                onCopyToClipboard: _copyToClipboard,
              )),
          SizedBox(height: 3.h),

          // Receipt Upload
          ReceiptUploadWidget(
            uploadedReceiptPath: uploadedReceiptPath,
            onReceiptUploaded: (path) {
              setState(() {
                uploadedReceiptPath = path;
              });
            },
          ),
          SizedBox(height: 4.h),

          // Process Payment Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _processPayment,
              style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
              child: Text(
                'Konfirmasi Pembayaran',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Help Text
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Informasi Penting',
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Pastikan nominal transfer sesuai dengan total tagihan\n'
                  '• Upload bukti pembayaran yang jelas dan terbaca\n'
                  '• Pembayaran akan diverifikasi dalam 1-2 jam\n'
                  '• Hubungi customer service jika ada kendala',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
