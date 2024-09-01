import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/constants/color_constants.dart';
import 'package:newsapp/constants/widgets/explore_card.dart';
import 'package:newsapp/constants/widgets/my_search_bar_2.dart';
import 'package:newsapp/constants/widgets/separator.dart';
import 'package:newsapp/controllers/search_controller.dart' as sc;
import 'package:newsapp/models/news.dart';

class Search extends StatefulWidget {
  final sc.SearchController controller;
  const Search({super.key, required this.controller});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> rotationAnimation;

  String keyword = '';
  String sortBy = 'relevancy';

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    rotationAnimation = Tween<double>(
      begin: -90 * pi / 180,
      end: 0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.ease,
    ));

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(
            color: ColorConstants.darkTextColor,
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        leading: AnimatedBuilder(
          animation: rotationAnimation,
          builder: (context, child) => Transform.rotate(
            angle: rotationAnimation.value,
            child: child,
          ),
          child: IconButton(
            onPressed: () {
              animationController.reverse();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: ColorConstants.darkTextColor,
              size: 30.r,
            ),
          ),
        ),
        titleSpacing: 0,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 14.h, left: 12.w, right: 12.w),
        child: Column(
          children: [
            MySearchBar2(
              onSubmitted: (keyword) {
                setState(() {
                  this.keyword = keyword;
                });
              },
              sortFunction: sortFunction,
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: keyword.isEmpty
                  ? Container()
                  : FutureBuilder(
                      future: widget.controller.fetchNews(
                        keyword: keyword,
                        sortBy: sortBy,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          if (widget.controller.getMessage == 'empty keyword') {
                            return Container();
                          } else if (widget.controller.getMessage == 'error') {
                            return Center(
                                child: Text(
                              'Oops, something went wrong.\nPlease try again later.',
                              textAlign: TextAlign.center,
                              style: errorTextStyle,
                            ));
                          } else if (widget.controller.getMessage ==
                              'no result') {
                            return Center(
                                child: Text(
                              'No results found.',
                              textAlign: TextAlign.center,
                              style: errorTextStyle,
                            ));
                          } else {
                            return ListView.separated(
                              itemCount: widget.controller.getNewsList!.length,
                              separatorBuilder: (context, index) =>
                                  Separator(height: 16.h),
                              itemBuilder: (context, index) {
                                News news =
                                    widget.controller.getNewsList![index];

                                final bool isLastItem = index ==
                                    widget.controller.getNewsList!.length - 1;
                                return Container(
                                  margin: isLastItem
                                      ? EdgeInsets.only(bottom: 60.h)
                                      : null,
                                  child: ExploreCard(news: news),
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void sortFunction() {
    final style = TextStyle(
      color: ColorConstants.darkTextColor,
      fontSize: 14.sp,
      fontFamily: 'SF Pro Text',
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -0.14,
    );
    showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromLTRB(1000, 160.h, 26.w, 0),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'publishedAt',
          child: Text('Latest', style: style),
        ),
        PopupMenuItem<String>(
          value: 'relevancy',
          child: Text('Relevancy', style: style),
        ),
        PopupMenuItem<String>(
          value: 'popularity',
          child: Text('Popularity', style: style),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          sortBy = value;
        });
      }
    });
  }

  TextStyle errorTextStyle = TextStyle(
    color: ColorConstants.darkTextColor,
    fontFamily: 'SF Pro Text',
    fontSize: 16.sp,
    height: 1.5,
    letterSpacing: -0.4,
  );

  Offset getgetBottomOffset(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Offset(0.0, screenSize.height);
  }
}
