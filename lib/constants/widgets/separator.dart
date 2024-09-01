import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Separator extends StatelessWidget {
  final double height;
  const Separator({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height),
      height: 0.8.h,
      decoration: BoxDecoration(
        color: const Color(0xFFDDE0E8),
        borderRadius: BorderRadius.circular(100.r),
      ),
    );
  }
}
