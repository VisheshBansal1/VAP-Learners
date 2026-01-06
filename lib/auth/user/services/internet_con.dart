import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class InternetChecker {
  bool connected = false;
  StreamSubscription<InternetConnectionStatus>? _subscription;

  Future<void> checkInternetCon() async {
    connected = await InternetConnectionChecker.instance.hasConnection;
    _showMsg(connected);
  }

  void startListening() {
    _subscription?.cancel(); //if subsription already exist close that
    _subscription = InternetConnectionChecker.instance.onStatusChange.listen((
      status,
    ) {
      final connected = status == InternetConnectionStatus.connected;
      _showMsg(connected);
    });
  }

  void _showMsg(bool connected) {
    final msg = connected
        ? '✅ Connected to Internet'
        : '❌ Not Connected to Internet';

    showSimpleNotification(
      Text(msg, style: const TextStyle(color: CupertinoColors.white)),
      background: connected
          ? CupertinoColors.activeGreen
          : CupertinoColors.systemRed,
    );
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }
}
