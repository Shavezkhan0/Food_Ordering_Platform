// lib/showBar/show_bar.dart
import 'package:flutter/material.dart';
import 'package:okados/config/config.dart';

void showSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: blackColor, width: 2),
            gradient: LinearGradient(colors: [
              primaryColor,
              secondaryColor,
            ]),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: TextStyle(color: whiteColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
