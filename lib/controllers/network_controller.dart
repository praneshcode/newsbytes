import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newsapp/constants/color_constants.dart';

class NetworkController {
  BuildContext context;
  late StreamSubscription<List<ConnectivityResult>> subscription;

  late bool isConnected;
  bool wasOffline = false;

  NetworkController(this.context) {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      isConnected = !result.contains(ConnectivityResult.none);

      if (!isConnected) {
        _showSnackBar('No connection', Colors.red);
        wasOffline = true;
      } else if (isConnected && wasOffline) {
        _showSnackBar('Back online', ColorConstants.primaryColor);
        wasOffline = false;
      }
    });
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'SF Pro Text',
            fontWeight: FontWeight.w500,
            height: 1.3,
            letterSpacing: -0.14,
          ),
        ),
      ),
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
