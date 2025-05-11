import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/constants/widgets/saved_card.dart';
import 'package:newsapp/constants/widgets/saved_date.dart';
import 'package:newsapp/models/news.dart';

class SavedListView extends StatelessWidget {
  final DateTime savedDate;
  final List<News> savedNewsList;

  const SavedListView({
    super.key,
    required this.savedDate,
    required this.savedNewsList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: SavedDate(savedDate: savedDate),
        ),
        SizedBox(height: 18.h),
        SizedBox(
          height: 186,
          child: ListView.separated(
            itemCount: savedNewsList.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 24.w),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 12.w : 0,
                right: index == savedNewsList.length - 1 ? 12.w : 0,
              ),
              child: SavedCard(news: savedNewsList[index]),
            ),
          ),
        ),
      ],
    );
  }
}
