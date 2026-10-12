import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import 'device_config_class.dart';

class CommonFunctions {
  /// Function to get the unique device identifier (IDFV for iOS, ANDROID_ID for Android).
  /// Automatically identifies the platform and returns the identifier.
  static Future<String> getDeviceIdentifier() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        final androidId = await androidIdPlugin.getId();
        print('Android ID -  $androidId');
        return androidId ?? 'Unknown Android ID';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;

        return iosInfo.identifierForVendor ??
            'Unknown iOS ID'; // Ensure non-null
      } else {
        return 'Unsupported platform';
      }
    } catch (e) {
      return 'Error fetching device identifier: $e';
    }
  }

  static String extractSecondElement(String? input) {
    if (input == null || input.isEmpty) return "";

    List<String> parts = input.split(',');

    // Check if the expected second element exists
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return parts[1];
    }

    return "";
  }
  static String extractSecondElementNew(String? input) {
    if (input == null || input.isEmpty) return "";

    List<String> parts = input.split(',');

    if (parts.length == 1 && parts[0].isNotEmpty) {
      // If there's only one element, return it
      return parts[0];
    }

    // If there are multiple elements, return the second if it exists
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return parts[1];
    }

    return "";
  }

  static String formatDateString(String? dateString) {
    try {
      if (dateString == null) {
        return "N/A";
      }

      DateTime parsedDate = DateTime.parse(dateString);
      String formattedDate =
          "${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year} ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}:${parsedDate.second.toString().padLeft(2, '0')}";
      return formattedDate;
    } catch (e) {
      return "Invalid Date Format";
    }
  }



  static void showToast(String message,
      {ToastGravity gravity = ToastGravity.BOTTOM,
      int timeInSec = 2,
      bool isSuccess = true,
      Color backgroundColor = Colors.black,
      Color textColor = Colors.white}) {
    Icon icon;
    if (isSuccess) {
      icon = Icon(Icons.check_circle, color: Colors.green);
    } else {
      icon = Icon(Icons.cancel, color: Colors.red);
    }
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: timeInSec,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
  static showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: AppSizes.fontSize(),
    );
  }
}

class MathUtil {
  static double wrap(double value, double min, double max) {
    double range = max - min;
    value = value - min;
    return min + ((value + range) % range);
  }
}
