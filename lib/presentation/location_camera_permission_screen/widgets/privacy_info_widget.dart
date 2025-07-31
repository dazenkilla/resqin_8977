import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PrivacyInfoWidget extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const PrivacyInfoWidget({
    Key? key,
    required this.isExpanded,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              // Header Row
              Row(
                children: [
                  Icon(
                    Icons.security,
                    size: 6.w,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'How we protect your data',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 6.w,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),

              // Expandable Content
              if (isExpanded) ...[
                SizedBox(height: 3.h),
                _buildPrivacyPoint(
                  context,
                  Icons.lock,
                  'Encrypted Storage',
                  'All your data is encrypted and stored securely on our servers.',
                ),
                SizedBox(height: 2.h),
                _buildPrivacyPoint(
                  context,
                  Icons.visibility_off,
                  'Location Privacy',
                  'Your location is only used during active emergency requests.',
                ),
                SizedBox(height: 2.h),
                _buildPrivacyPoint(
                  context,
                  Icons.share_location,
                  'Limited Sharing',
                  'Location data is only shared with emergency responders and hospitals.',
                ),
                SizedBox(height: 2.h),
                _buildPrivacyPoint(
                  context,
                  Icons.delete_forever,
                  'Data Control',
                  'You can request deletion of your data at any time through settings.',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyPoint(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.tertiary.withAlpha(26),
          ),
          child: Icon(
            icon,
            size: 4.w,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
