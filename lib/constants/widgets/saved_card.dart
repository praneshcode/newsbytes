import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newsapp/constants/color_constants.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/providers/saved_news_list_provider.dart';
import 'package:newsapp/constants/widgets/news_web_view.dart';
import 'package:vibration/vibration.dart';

class SavedCard extends StatefulWidget {
  final News news;
  const SavedCard({super.key, required this.news});

  @override
  State<SavedCard> createState() => _SavedCardState();
}

class _SavedCardState extends State<SavedCard> {
  @override
  Widget build(BuildContext context) {
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
      child: SizedBox(
        width: 208.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
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
                                    fontSize: 12,
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
                              fontSize: 12,
                              height: 1.71,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return Positioned(
                      top: 8.67.h,
                      right: 9.9.w,
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
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.news.title,
                    style: const TextStyle(
                      color: ColorConstants.darkTextColor,
                      fontSize: 18,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w700,
                      height: 1.6,
                      letterSpacing: -0.36,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
