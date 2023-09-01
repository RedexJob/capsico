import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController snackbarView({
  @required BuildContext context,
  @required String title,
  @required String message,
  bool isSuccess = false,
  bool isError = false,
}) {
  return Get.snackbar(title, message,
      colorText: isSuccess == true || isError == true
          ? Colors.white
          : Colors.blue,
      backgroundColor: isSuccess == true
          ? Colors.green
          : isError == true
          ? Colors.red
          : Colors.blue,
      snackPosition: SnackPosition.BOTTOM,
      dismissDirection: DismissDirection.horizontal,
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 50));
}
