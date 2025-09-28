import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://192.168.1.103:5000/api"; // PC IP for web
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:5000/api"; // Android emulator
    } else if (Platform.isIOS) {
      return "http://localhost:5000/api"; // iOS simulator
    } else {
      return "http://localhost:5000/api"; // fallback
    }
  }
}
