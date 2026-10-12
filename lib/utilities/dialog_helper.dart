import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../main.dart';

class DialogHelper {
  // Success Dialog
  static void showSuccessDialog(BuildContext context, String message) {
    PanaraInfoDialog.show(
      context,
      title: "Success!",
      message: message,
      buttonText: "OK",
      onTapDismiss: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.success,
    );
  }

  // Failure/Error Dialog
  static void showErrorDialog(BuildContext context, String message) {
    // 🔹 Use active context from navigatorKey or fallback to context
    final dialogContext = MyApp.navigatorKey.currentContext ?? context;

    PanaraInfoDialog.show(
      dialogContext,
      title: "Error!",
      message: message,
      buttonText: "OK",
      onTapDismiss: () {
        // 🔹 Direct top-overlay pop via GlobalKey
        if (MyApp.navigatorKey.currentState?.canPop() ?? false) {
          MyApp.navigatorKey.currentState?.pop();
        }
      },
      panaraDialogType: PanaraDialogType.error,
    );
  }
  // Message-Only Dialog
  static void showMessageDialog(BuildContext context, String message) {
    PanaraInfoDialog.show(
      context,
      title: "Information",
      message: message,
      buttonText: "OK",
      onTapDismiss: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.normal,
    );
  }

  static void showConfirmationDialog(
      BuildContext context,
      String message,
      VoidCallback onAccept,
      VoidCallback onReject, {
        String accept = "Accept",
        String reject = "Reject",
      }) {
    PanaraConfirmDialog.show(
      context,
      title: "Confirm",
      message: message,
      confirmButtonText: accept,
      cancelButtonText: reject,
      onTapConfirm: () {
        Navigator.pop(context);
        onAccept();
      },
      onTapCancel: () {
        Navigator.pop(context);
        onReject();
      },
      panaraDialogType: PanaraDialogType.warning, // Can be warning, error, or help type
    );
  }
}