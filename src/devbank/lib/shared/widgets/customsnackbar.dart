import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

void showCustomSnackbar({
  required BuildContext context,
  required String text,
  required Color color,
  IconData? icon,
  Duration duration = const Duration(seconds: 3),
}) {
  Flushbar(
    message: text,
    icon: icon != null
        ? Icon(
            icon,
            size: 28.0,
            color: Colors.white,
          )
        : null,
    flushbarStyle: FlushbarStyle.FLOATING,
    shouldIconPulse: true,
    duration: duration,
    flushbarPosition: FlushbarPosition.BOTTOM,
    backgroundColor: color,
    margin: const EdgeInsets.all(8.0),
    borderRadius: BorderRadius.circular(12.0),
    animationDuration: const Duration(milliseconds: 400),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        offset: const Offset(0, 3),
        blurRadius: 6.0,
      ),
    ],
  ).show(context);
}
