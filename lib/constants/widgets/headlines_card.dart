import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newsapp/constants/color_constants.dart';
import 'package:newsapp/constants/widgets/news_web_view.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/providers/saved_news_list_provider.dart';
import 'package:vibration/vibration.dart';

class HeadlinesCard extends ConsumerStatefulWidget {
  final News news;
  const HeadlinesCard({super.key, required this.news});

  @override
  ConsumerState<HeadlinesCard> createState() => _HeadlinesCardState();
}

class _HeadlinesCardState extends ConsumerState<HeadlinesCard> {
  @override
  Widget build(BuildContext context) {
    final List<News> savedNewsList = ref.watch(savedNewsListProvider);

    bool isSaved = false;
    for (News savedNews in savedNewsList) {
      if (widget.news.url == savedNews.url) {
        isSaved = true;
        setState(() {
          widget.news.savedAt = savedNews.savedAt;
        });
        break;
      }
    }

    if (!isSaved) {
      setState(() {
        widget.news.savedAt = null;
      });
    }

    return InkWell(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return NewsWebView(news: widget.news);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
          reverseTransitionDuration: const Duration(milliseconds: 500),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                height: 160.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3F5),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: widget.news.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: FadeInImage.assetNetwork(
                          fadeInDuration: Durations.short2,
                          width: double.infinity,
                          height: double.infinity,
                          image: widget.news.imageUrl,
                          fit: BoxFit.fill,
                          placeholder: 'assets/card_background.png',
                          placeholderColor: const Color(0xFFF2F3F5),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Couldn\'t load image',
                                style: TextStyle(
                                  color: ColorConstants.darkTextColor,
                                  fontFamily: 'SF Pro Text',
                                  fontSize: 14,
                                  height: 1.71,
                                  letterSpacing: -0.28,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No image found',
                          style: TextStyle(
                            color: ColorConstants.darkTextColor,
                            fontFamily: 'SF Pro Text',
                            fontSize: 14,
                            height: 1.71,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ),
              ),
              Positioned(
                top: 14.h,
                right: 16.w,
                child: GestureDetector(
                  onTap: () {
                    Vibration.vibrate(duration: 55);

                    setState(() {
                      ref
                          .read(savedNewsListProvider.notifier)
                          .toggleSaved(widget.news);
                    });
                  },
                  child: widget.news.savedAt != null
                      ? SvgPicture.asset(
                          'assets/navbar/saved_selected.svg',
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        )
                      : SvgPicture.asset(
                          'assets/navbar/saved.svg',
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.news.title,
                  style: TextStyle(
                    color: ColorConstants.darkTextColor,
                    fontSize: 20.sp,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                Text(
                  _formatTime(widget.news.publishedAt),
                  style: TextStyle(
                    color: ColorConstants.lightTextColor,
                    fontSize: 12.sp,
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    letterSpacing: -0.24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return DateFormat('MMM d, y').format(dateTime);
    } else if (difference.inDays > 7) {
      return DateFormat('MMM d').format(dateTime);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
