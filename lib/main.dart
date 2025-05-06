import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/constants/theme_constants.dart';
import 'package:newsapp/screens/navbar.dart';
import 'package:newsapp/screens/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('first_launch') ?? true;
  if (isFirstLaunch) {
    await prefs.setStringList('saved_news', []);
    await prefs.setBool('first_launch', false);
  }

  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: false,
        builder: (context) {
          return MyApp(isFirstLaunch: isFirstLaunch);
        },
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isFirstLaunch;
  const MyApp({super.key, required this.isFirstLaunch});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeConstants.themeData,
        home: widget.isFirstLaunch ? const Onboarding() : const NavBar(),
      ),
    );
  }
}
