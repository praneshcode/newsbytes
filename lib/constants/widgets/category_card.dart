import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/constants/color_constants.dart';
import 'package:newsapp/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      decoration: BoxDecoration(
        color: category.isSelected
            ? ColorConstants.primaryColor
            : const Color(0xFFDEE1E9),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category.category,
            style: TextStyle(
              color: category.isSelected
                  ? Colors.white
                  : ColorConstants.darkTextColor,
              fontFamily: 'SF Pro Text',
              fontSize: 14,
              height: 1.71,
              letterSpacing: -0.28,
            ),
          ),
          // if (category.cross && category.isSelected) const SizedBox(width: 4),
          // if (category.cross && category.isSelected)
          //   SvgPicture.asset(
          //     'assets/icons/cross.svg',
          //     width: 10,
          //     height: 10,
          //     colorFilter:
          //         const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          //   ),
        ],
      ),
    );
  }
}
