import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart';
import 'package:newsapp/constants/color_constants.dart';
import 'package:newsapp/screens/navbar.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            SizedBox(height: screenHeight * 0.09),
            images(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.0375),
            const Text(
              'Stay informed with\ndaily news bytes',
              style: TextStyle(
                color: ColorConstants.darkTextColor,
                fontSize: 32,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w700,
                height: 1.3,
                letterSpacing: -0.48,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              'Latest headlines brought directly\nto your device',
              style: TextStyle(
                color: ColorConstants.lightTextColor,
                fontSize: 20,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: -0.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.05),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
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
              },
              child: Container(
                width: screenWidth * 0.833333,
                height: screenHeight * 0.075,
                decoration: BoxDecoration(
                  color: ColorConstants.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Get Started',
                    style: TextStyle(
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
          ],
        ),
      ),
    );
  }

  Widget images(double screenWidth, double screenHeight) {
    return Column(
      children: [
        carousel_slider.CarouselSlider(
          items: ['image 1', 'image 2', 'image 3'].map((e) {
            return Container(
              width: screenWidth * 0.611111,
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
            height: screenHeight * 0.4,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            viewportFraction: 0.625,
            onPageChanged: (index, _) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [0, 1, 2].map((index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: currentIndex == index ? 12 : 8,
              height: currentIndex == index ? 12 : 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index
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
