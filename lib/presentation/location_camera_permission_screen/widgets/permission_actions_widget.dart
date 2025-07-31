import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PermissionActionsWidget extends StatelessWidget {
  final bool isLocationGranted;
  final bool isCameraGranted;
  final bool isLoading;
  final VoidCallback onGrantPermissions;
  final VoidCallback onSkip;

  const PermissionActionsWidget({
    Key? key,
    required this.isLocationGranted,
    required this.isCameraGranted,
    required this.isLoading,
    required this.onGrantPermissions,
    required this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool allPermissionsGranted = isLocationGranted && isCameraGranted;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Permission Status Indicator
          if (!allPermissionsGranted) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 5.w,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Permissions Required',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          _getPermissionStatusText(),
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
          ],

          // Primary Action Button
          SizedBox(
            width: double.infinity,
            height: 7.h,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : (allPermissionsGranted
                      ? onGrantPermissions
                      : onGrantPermissions),
              style: ElevatedButton.styleFrom(
                backgroundColor: allPermissionsGranted
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 6.w,
                      height: 6.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      allPermissionsGranted
                          ? 'Continue to ResQin'
                          : 'Grant Permissions',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 2.h),

          // Skip Button (only show if not all permissions granted)
          if (!allPermissionsGranted) ...[
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: TextButton(
                onPressed: isLoading ? null : onSkip,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Skip for now',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

            SizedBox(height: 1.h),

            // Warning Text for Skip
            Text(
              'Note: Some emergency features may be limited without permissions',
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  String _getPermissionStatusText() {
    if (!isLocationGranted && !isCameraGranted) {
      return 'Location and Camera permissions needed';
    } else if (!isLocationGranted) {
      return 'Location permission needed';
    } else if (!isCameraGranted) {
      return 'Camera permission needed';
    }
    return 'All permissions granted';
  }
}
