import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/constants/color_constants.dart';

class SavedDate extends StatelessWidget {
  final DateTime savedDate;
  const SavedDate({super.key, required this.savedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDEE1E9),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatTime(savedDate),
            style: TextStyle(
              color: ColorConstants.darkTextColor,
              fontSize: 14.sp,
              fontFamily: 'SF Pro Text',
              fontWeight: FontWeight.w700,
              height: 1.3,
              letterSpacing: -0.7,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();

    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      return 'Today';
    } else if (dateTime.year != now.year) {
      return DateFormat('MMM d, y').format(dateTime);
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
