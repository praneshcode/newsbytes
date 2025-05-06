import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newsapp/constants/color_constants.dart';
import 'package:newsapp/screens/navbar.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _title = [
    'Stay tuned with\ndaily updates',
    'Explore news from different topics',
    'Save articles for reading later',
  ];
  final List<String> _subtitle = [
    'Get the latest breaking news and updates right at your fingertips',
    'Browse news from business, entertainment, sports, and more',
    'Save your favorite articles and read them whenever you want',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  late double widthRatio;
  late double heightRatio;
  @override
  Widget build(BuildContext context) {
    widthRatio = MediaQuery.of(context).size.width / 360;
    heightRatio = MediaQuery.of(context).size.height / 800;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(width: double.infinity),
                SizedBox(height: heightRatio * 82),
                images(_currentIndex),
                SizedBox(height: heightRatio * 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthRatio * 36),
                  child: Text(
                    _title[_currentIndex],
                    style: const TextStyle(
                      color: ColorConstants.darkTextColor,
                      fontSize: 34,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: heightRatio * 26),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthRatio * 20),
                  child: Text(
                    _subtitle[_currentIndex],
                    style: const TextStyle(
                      color: ColorConstants.lightTextColor,
                      fontSize: 20,
                      fontFamily: 'SF Pro Text',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      letterSpacing: -0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: heightRatio * 60),
                GestureDetector(
                  onTap: () {
                    if (_currentIndex == 2) {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const NavBar();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: CurvedAnimation(
                                parent: animation,
                                curve: Curves.ease,
                              ),
                              child: child,
                            );
                          },
                        ),
                      );
                    } else {
                      setState(() {
                        _animationController.reverse().then((_) {
                          setState(() {
                            _currentIndex = (_currentIndex + 1) % 3;
                          });
                          _animationController.forward();
                        });
                      });
                    }
                  },
                  child: Container(
                    width: widthRatio * 300,
                    height: heightRatio * 60,
                    decoration: BoxDecoration(
                      color: ColorConstants.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: SizedBox(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            _currentIndex == 2 ? 'Get Started' : 'Next',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget images(int index) {
    List<String> imageList = [
      'assets/onboarding/1.svg',
      'assets/onboarding/2.svg',
      'assets/onboarding/3.svg',
    ];

    return Column(
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: SvgPicture.asset(
            imageList[index],
            width: widthRatio * 360,
            height: heightRatio * 305,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: heightRatio * 40),
        SizedBox(
          height: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [0, 1, 2].map((index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: _currentIndex == index ? 12 : 8,
                height: _currentIndex == index ? 12 : 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? ColorConstants.primaryColor
                      : ColorConstants.accentColor,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget get imagesOld {
    return Column(
      children: [
        carousel_slider.CarouselSlider(
          items: ['image 1', 'image 2', 'image 3'].map((e) {
            return Container(
              width: widthRatio * 220,
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  e,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }).toList(),
          options: carousel_slider.CarouselOptions(
            height: heightRatio * 320,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            viewportFraction: 140 / 220,
            onPageChanged: (index, _) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: heightRatio * 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [0, 1, 2].map((index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == index ? 12 : 8,
              height: _currentIndex == index ? 12 : 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? ColorConstants.primaryColor
                    : ColorConstants.accentColor,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
