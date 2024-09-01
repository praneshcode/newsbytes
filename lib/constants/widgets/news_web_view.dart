import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newsapp/constants/color_constants.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/providers/saved_news_list_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends ConsumerStatefulWidget {
  final News news;
  const NewsWebView({super.key, required this.news});

  @override
  ConsumerState<NewsWebView> createState() => _NewsWebViewState();
}

class _NewsWebViewState extends ConsumerState<NewsWebView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> rotationAnimation;

  late final WebViewController controller;

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

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(widget.news.url))
      ..clearCache()
      ..clearLocalStorage();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
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
                          ColorConstants.darkTextColor, BlendMode.srcIn),
                    )
                  : SvgPicture.asset(
                      'assets/navbar/saved.svg',
                      colorFilter: const ColorFilter.mode(
                          ColorConstants.darkTextColor, BlendMode.srcIn),
                    ),
            ),
          )
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
