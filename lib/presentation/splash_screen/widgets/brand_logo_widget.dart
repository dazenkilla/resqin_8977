import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class BrandLogoWidget extends StatelessWidget {
  final AnimationController logoController;

  const BrandLogoWidget({
    Key? key,
    required this.logoController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ResQin Logo with Pulse Animation
        AnimatedBuilder(
          animation: logoController,
          builder: (context, child) {
            return Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withAlpha(77),
                    blurRadius: 20 * logoController.value,
                    spreadRadius: 5 * logoController.value,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.local_hospital,
                  size: 12.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
        ),

        SizedBox(height: 3.h),

        // ResQin Brand Name
        Text(
          'Ambulans.co',
          style: GoogleFonts.inter(
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Emergency Medical Services',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white.withAlpha(230),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
