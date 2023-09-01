import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/Widgets/loading_dialog.dart';
import 'package:flutter_grocery/Widgets/pref_string.dart';
import 'package:flutter_grocery/Widgets/snackbar_view.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/view/screens/auth/otp_screen.dart';
import 'package:flutter_grocery/view/screens/home/home_screens.dart';
import 'package:flutter_grocery/view/screens/menu/menu_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpController extends GetxController {

  Future sendOTP({@required BuildContext context, isLoader = false, String location, String mobileNumber}) async {
    if (isLoader) {
      showLoadingDialog(context: Get.context);
    }
    var response = await http.post(
      Uri.parse("https://admin.capsico.co.in/api/v1/auth/sendOtp"),
      body:
        {
          "phone": mobileNumber,
          "location": location,
        },
    );
    if (response.statusCode == 200) {
      if (isLoader) {
        hideLoadingDialog(context: Get.context);
      }
      var data = jsonDecode(response.body);
      SharedPreferenceIml.shared.instance
          .setInt("userId", data["data"]["user_id"]);
      debugPrint("--- DATA ---> $data");
      snackbarView(context: context, title: "Success", message: jsonDecode(response.body)["message"], isSuccess: true);
      Get.to(() => OtpScreen());
    } else {
      if (isLoader) {
        hideLoadingDialog(context: Get.context);
      }
      debugPrint("------else----");
    }
  }

  Future register({@required BuildContext context, isLoader = false, String otp}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int userId = SharedPreferenceIml.shared.instance
        .getInt("userId");
    if (isLoader) {
      showLoadingDialog(context: Get.context);
    }
    var response = await http.post(
      Uri.parse("https://admin.capsico.co.in/api/v1/auth/registerByOtp"),
      body:
      {
        "otp": otp,
        "user_id": userId.toString(),
      },
    );
    if (response.statusCode == 200) {
      if (isLoader) {
        hideLoadingDialog(context: Get.context);
      }
      var data = jsonDecode(response.body);
      sharedPreferences.setString(AppConstants.TOKEN, data["token"]);

      debugPrint("--- DATA ---> $data");
      snackbarView(context: context, title: "Success", message: "OTP verify successfully", isSuccess: true);
   Get.offAll(()=> MenuScreen());
    } else {
      if (isLoader) {
        hideLoadingDialog(context: Get.context);
      }
      debugPrint("------else----");
    }
  }

  Future loginSendOTP({@required BuildContext context, isLoader = false, String mobileNumber}) async {
    if (isLoader) {
      showLoadingDialog(context: Get.context);
    }
    var response = await http.post(
      Uri.parse("https://admin.capsico.co.in/api/v1/auth/sendLoginOtp"),
      body:
      {
        "phone": mobileNumber,
      },
    );
    if (response.statusCode == 200) {
      if (isLoader) {
        hideLoadingDialog(context: Get.context);
      }
      var data = jsonDecode(response.body);
      SharedPreferenceIml.shared.instance
          .setInt("userId", data["data"]["user_id"]);
      debugPrint("--- DATA ---> $data");
      snackbarView(context: context, title: "Success", message: jsonDecode(response.body)["message"], isSuccess: true);
      Get.to(() => OtpScreen());
    } else {
      if (isLoader) {
        hideLoadingDialog(context: Get.context);
      }
      debugPrint("------else----");
    }
  }

  Future login({@required BuildContext context, isLoader = false, String otp}) async {
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int userId = SharedPreferenceIml.shared.instance
        .getInt("userId");
    if (isLoader) {
      showLoadingDialog(context: Get.context);
    }
    var response = await http.post(
      Uri.parse("https://admin.capsico.co.in/api/v1/auth/loginByOtp"),
      body:
      {
        "otp": otp,
        "user_id": userId.toString(),
      },
    );
    if (response.statusCode == 200) {
      if (isLoader) {
        hideLoadingDialog(context: Get.context);
      }
      var data = jsonDecode(response.body);
      sharedPreferences.setString(AppConstants.TOKEN, data["token"]);
      debugPrint("--- DATA ---> $data");
      snackbarView(context: context, title: "Success", message: "OTP verify successfully", isSuccess: true);
      Get.offAll(()=> MenuScreen());
    } else {
      if (isLoader) {
        hideLoadingDialog(context: Get.context);
      }
      debugPrint("------else----");
    }
  }
}
