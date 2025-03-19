import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// 引入 flutter/services.dart 來使用 MethodChannel

class BatteryLevel {
  static const methodChannel = MethodChannel(
    // A name must be the same as 
    // the name in the native implementation. 
    'io.flutterengineering.battery/methods',
  );

  static Future<int?> getBatteryLevel() async {
    try {
      final batteryLevel = await methodChannel.invokeMethod<int>(
        'getBatteryLevel',
      );
      return batteryLevel;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
} 