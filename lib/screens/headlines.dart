import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/constants/color_constants.dart';
import 'package:newsapp/constants/widgets/separator.dart';
import 'package:newsapp/constants/widgets/headlines_card.dart';
import 'package:newsapp/controllers/headlines_controller.dart';
import 'package:newsapp/models/news.dart';

class Headlines extends StatefulWidget {
  final HeadlinesController controller;
  const Headlines({super.key, required this.controller});

  @override
  State<Headlines> createState() => _HeadlinesState();
}

class _HeadlinesState extends State<Headlines> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Headlines',
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
        child: FutureBuilder(
          future: widget.controller.fetchNews(
            country: 'in',
            category: 'general',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //loading
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.primaryColor,
                  strokeWidth: 3,
                ),
              );
            } else if (snapshot.hasError) {
              //error
              return Center(
                child: Text(
                  'Oops, something went wrong.\nPlease try again later.',
                  textAlign: TextAlign.center,
                  style: errorTextStyle,
                ),
              );
            } else {
              //success
              if (widget.controller.getNewsList == null) {
                return Center(
                  child: Text(
                    'Oops, something went wrong.\nPlease try again later.',
                    textAlign: TextAlign.center,
                    style: errorTextStyle,
                  ),
                );
              }
              return ListView.separated(
                itemCount: widget.controller.getNewsList!.length,
                separatorBuilder: (context, index) => Separator(height: 16.h),
                itemBuilder: (context, index) {
                  News news = widget.controller.getNewsList![index];

                  final bool isLastItem =
                      index == widget.controller.getNewsList!.length - 1;
                  return Container(
                    margin: isLastItem ? EdgeInsets.only(bottom: 40.h) : null,
                    child: HeadlinesCard(news: news),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  TextStyle errorTextStyle = TextStyle(
      color: ColorConstants.darkTextColor,
      fontFamily: 'SF Pro Text',
      fontSize: 16.sp,
      height: 1.5,
      letterSpacing: -0.4);
}
