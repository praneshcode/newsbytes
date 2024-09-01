import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MySearchBar1 extends StatefulWidget {
  const MySearchBar1({super.key});

  @override
  State<MySearchBar1> createState() => _MySearchBar1State();
}

class _MySearchBar1State extends State<MySearchBar1> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFD0D5DD),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter:
                  const ColorFilter.mode(Color(0xFF667085), BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Search',
                style: TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 16,
                  fontFamily: 'SF Pro Text',
                  height: 1.5,
                  letterSpacing: -0.32,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/icons/sort.svg',
              colorFilter:
                  const ColorFilter.mode(Color(0xFF667085), BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
