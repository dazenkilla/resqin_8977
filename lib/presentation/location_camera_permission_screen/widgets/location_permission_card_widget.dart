import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class LocationPermissionCardWidget extends StatelessWidget {
  final bool isGranted;
  final VoidCallback onTap;

  const LocationPermissionCardWidget({
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
                  // Location Icon
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
                      Icons.location_on,
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
                          'Location Access',
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

              // Map Illustration
              Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.secondary.withAlpha(26),
                ),
                child: Stack(
                  children: [
                    // Map Background Pattern
                    CustomPaint(
                      size: Size(double.infinity, 20.h),
                      painter: _MapPatternPainter(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withAlpha(51),
                      ),
                    ),

                    // Ambulance and Location Icons
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_hospital,
                            size: 8.w,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            width: 20.w,
                            height: 1,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(0.5),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Icon(
                            Icons.my_location,
                            size: 6.w,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Description
              Text(
                'Location access helps us dispatch ambulances to your exact location quickly and accurately during emergencies. This ensures faster response times and better service.',
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

class _MapPatternPainter extends CustomPainter {
  final Color color;

  _MapPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw grid pattern
    final spacing = size.width / 8;

    for (int i = 0; i < 8; i++) {
      // Vertical lines
      canvas.drawLine(
        Offset(spacing * i, 0),
        Offset(spacing * i, size.height),
        paint,
      );

      // Horizontal lines
      if (i < 5) {
        canvas.drawLine(
          Offset(0, (size.height / 4) * i),
          Offset(size.width, (size.height / 4) * i),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
