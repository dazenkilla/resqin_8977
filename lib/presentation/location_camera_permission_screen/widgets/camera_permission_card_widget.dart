import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CameraPermissionCardWidget extends StatelessWidget {
  final bool isGranted;
  final VoidCallback onTap;

  const CameraPermissionCardWidget({
    Key? key,
    required this.isGranted,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isGranted
              ? Theme.of(context).colorScheme.tertiary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: isGranted ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              // Header Row
              Row(
                children: [
                  // Camera Icon
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isGranted
                          ? Theme.of(context).colorScheme.tertiary.withAlpha(26)
                          : Theme.of(context)
                              .colorScheme
                              .secondary
                              .withAlpha(26),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 6.w,
                      color: isGranted
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Title and Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Camera Access',
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Icon(
                              isGranted
                                  ? Icons.check_circle
                                  : Icons.access_time,
                              size: 4.w,
                              color: isGranted
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              isGranted ? 'Granted' : 'Required',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: isGranted
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Toggle Switch
                  Switch(
                    value: isGranted,
                    onChanged: isGranted ? null : (_) => onTap(),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Receipt Scanning Illustration
              Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.secondary.withAlpha(26),
                ),
                child: Stack(
                  children: [
                    // Receipt Mockup
                    Center(
                      child: Container(
                        width: 30.w,
                        height: 15.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Receipt Header
                              Container(
                                width: double.infinity,
                                height: 1.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),

                              SizedBox(height: 1.h),

                              // Receipt Lines
                              ...List.generate(
                                  4,
                                  (index) => Padding(
                                        padding: EdgeInsets.only(bottom: 0.5.h),
                                        child: Container(
                                          width: (25 - index * 3).w,
                                          height: 0.5.h,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant
                                                .withAlpha(77),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                      )),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Camera Scan Overlay
                    Positioned(
                      top: 2.h,
                      right: 8.w,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 4.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Description
              Text(
                'Camera access allows you to scan receipts for payment verification and capture medical documents when needed. This helps streamline the billing process.',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
