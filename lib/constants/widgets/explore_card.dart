import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/constants/color_constants.dart';
import 'package:newsapp/constants/widgets/news_web_view.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/providers/saved_news_list_provider.dart';
import 'package:vibration/vibration.dart';

class ExploreCard extends ConsumerStatefulWidget {
  final News news;

  const ExploreCard({super.key, required this.news});

  @override
  ConsumerState<ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends ConsumerState<ExploreCard> {
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
      child: SizedBox(
        height: 110,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: widget.news.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
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
                                fontSize: 10,
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
                          fontSize: 10,
                          height: 1.71,
                          letterSpacing: -0.28,
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.news.title,
                      style: const TextStyle(
                        color: ColorConstants.darkTextColor,
                        fontSize: 17,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        letterSpacing: -0.17,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatTime(widget.news.publishedAt),
                          style: const TextStyle(
                            color: ColorConstants.lightTextColor,
                            fontSize: 12,
                            fontFamily: 'SF Pro Text',
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            letterSpacing: -0.24,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Vibration.vibrate(duration: 55);

                            setState(() {
                              ref
                                  .read(savedNewsListProvider.notifier)
                                  .toggleSaved(widget.news);
                            });
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBEDF2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: widget.news.savedAt != null
                                  ? SvgPicture.asset(
                                      'assets/icons/saved_selected.svg',
                                      colorFilter: const ColorFilter.mode(
                                          Color(0xFF7F8493), BlendMode.srcIn),
                                    )
                                  : SvgPicture.asset(
                                      'assets/icons/saved.svg',
                                      colorFilter: const ColorFilter.mode(
                                          Color(0xFF7F8493), BlendMode.srcIn),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
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
