import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoadingDialog({BuildContext context}) {
  Future.delayed(Duration.zero, () {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 0, 15, 109)),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  });
}

void hideLoadingDialog({BuildContext context, bool istrue = false}) {
  Get.back(closeOverlays: istrue);
}
