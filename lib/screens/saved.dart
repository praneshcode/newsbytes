import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/constants/color_constants.dart';
import 'package:newsapp/constants/widgets/saved_list_view.dart';
import 'package:newsapp/constants/widgets/separator.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/providers/saved_news_list_provider.dart';

class Saved extends ConsumerStatefulWidget {
  const Saved({super.key});

  @override
  ConsumerState<Saved> createState() => _SavedState();
}

class _SavedState extends ConsumerState<Saved> {
  @override
  Widget build(BuildContext context) {
    final List<List<News>> groupedNews =
        groupAndSortNews(ref.watch(savedNewsListProvider));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved',
          style: TextStyle(
            color: ColorConstants.darkTextColor,
            fontSize: 32.sp,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 14.h, left: 12.w, right: 12.w),
        child: groupedNews.isEmpty
            ? Center(
                child: Text(
                  'No saved news.',
                  style: TextStyle(
                    color: ColorConstants.darkTextColor,
                    fontFamily: 'SF Pro Text',
                    fontSize: 16.sp,
                    height: 1.5,
                    letterSpacing: -0.4,
                  ),
                ),
              )
            : ListView.separated(
                itemCount: groupedNews.length,
                separatorBuilder: (context, index) => Separator(height: 22.h),
                itemBuilder: (context, index) {
                  return SavedListView(
                    savedDate: groupedNews[index][0].savedAt!,
                    savedNewsList: groupedNews[index],
                  );
                },
              ),
      ),
    );
  }

  List<List<News>> groupAndSortNews(List<News> newsList) {
    Map<DateTime, List<News>> groupedNews = {};
    for (var news in newsList) {
      var savedAt =
          DateTime(news.savedAt!.year, news.savedAt!.month, news.savedAt!.day);
      if (groupedNews.containsKey(savedAt)) {
        groupedNews[savedAt]!.add(news);
      } else {
        groupedNews[savedAt] = [news];
      }
    }

    List<DateTime> sortedKeys = groupedNews.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    List<List<News>> result = [];
    for (var key in sortedKeys) {
      groupedNews[key]!.sort((a, b) => b.savedAt!.compareTo(a.savedAt!));
      result.add(groupedNews[key]!);
    }

    return result;
  }
}
