import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/constants/color_constants.dart';
import 'package:newsapp/constants/widgets/my_search_bar_1.dart';
import 'package:newsapp/constants/widgets/separator.dart';
import 'package:newsapp/constants/widgets/category_card.dart';
import 'package:newsapp/constants/widgets/explore_card.dart';
import 'package:newsapp/controllers/headlines_controller.dart';
import 'package:newsapp/models/category.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/screens/search.dart';
import 'package:newsapp/controllers/search_controller.dart' as sc;

class Explore extends StatefulWidget {
  final HeadlinesController controller;
  const Explore({super.key, required this.controller});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<Category> categories = Category.getCategories;
  String selectedCategory = 'Business';
  String dropDownValue = 'in';

  Map<String, List<News>?> storedNewsMap = {
    'Business': null,
    'Technology': null,
    'Entertainment': null,
    'Sports': null,
    'Science': null,
    'Health': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore',
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
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return Search(controller: sc.SearchController());
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
                        child: child,
                      );
                    },
                    reverseTransitionDuration:
                        const Duration(milliseconds: 500),
                  ),
                );
              },
              child: const MySearchBar1(),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 32,
              child: ListView.separated(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        for (int i = 0; i < categories.length; i++) {
                          if (i == index) {
                            categories[i].isSelected = true;
                            selectedCategory = categories[i].category;
                          } else {
                            categories[i].isSelected = false;
                          }
                        }
                      });
                    },
                    child: CategoryCard(category: categories[index]),
                  );
                },
              ),
            ),
            // SizedBox(height: 16.h),
            // dropDown,
            SizedBox(height: 18.h),
            if (storedNewsMap[selectedCategory] == null)
              Expanded(
                child: FutureBuilder(
                  future: widget.controller.fetchNews(
                    country: 'us',
                    category: selectedCategory,
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
                      storedNewsMap[selectedCategory] =
                          widget.controller.getNewsList;

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
                        separatorBuilder: (context, index) =>
                            Separator(height: 16.h),
                        itemBuilder: (context, index) {
                          News news = widget.controller.getNewsList![index];

                          final bool isLastItem = index ==
                              widget.controller.getNewsList!.length - 1;
                          return Container(
                            margin: isLastItem
                                ? EdgeInsets.only(bottom: 40.h)
                                : null,
                            child: ExploreCard(news: news),
                          );
                        },
                      );
                    }
                  },
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: storedNewsMap[selectedCategory]!.length,
                  separatorBuilder: (context, index) => Separator(height: 16.h),
                  itemBuilder: (context, index) {
                    News news = storedNewsMap[selectedCategory]![index];

                    final bool isLastItem =
                        index == widget.controller.getNewsList!.length - 1;
                    return Container(
                      margin: isLastItem ? EdgeInsets.only(bottom: 40.h) : null,
                      child: ExploreCard(news: news),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget get dropDown {
    final style = TextStyle(
      color: ColorConstants.darkTextColor,
      fontFamily: 'SF Pro Text',
      fontSize: 16.sp,
      height: 1.5,
      letterSpacing: -0.4,
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: DropdownButton(
        borderRadius: BorderRadius.circular(8),
        value: dropDownValue,
        underline: Container(),
        isDense: true,
        onChanged: (value) {
          setState(() {
            dropDownValue = value!;
          });
        },
        items: [
          DropdownMenuItem<String>(
            value: 'in',
            child: Text(
              'India',
              style: style,
            ),
          ),
          DropdownMenuItem<String>(
            value: '',
            child: Text(
              'World',
              style: style,
            ),
          )
        ],
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
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
