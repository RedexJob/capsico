import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/Controller/sign_up_controller.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final signUpController = Get.put(SignUpController());
 TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  // TextEditingController? textEditingController1;

String _comingSms = '';




  Future<void> initSmsListener() async {

    String comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      _comingSms = comingSms;
      print("====>Message: ${_comingSms}");
      print("=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=${_comingSms[0]}");
      _emailController.text = _comingSms[15] + _comingSms[16] + _comingSms[17] + _comingSms[18]
          + _comingSms[19] + _comingSms[20]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSmsListener();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) : null,
      body: SafeArea(
        child: Scrollbar(
          child: Center(
            child: SingleChildScrollView(
              padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(0) : EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 560 : MediaQuery.of(context).size.height),
                child: Center(
                  child: Column(
                    children: [
                      ResponsiveHelper.isDesktop(context)
                          ? SizedBox(
                        height: 50,
                      )
                          : SizedBox(),
                      Container(
                        width: size.width > 700 ? 700 : size.width,
                        padding: ResponsiveHelper.isDesktop(context)
                            ? EdgeInsets.symmetric(horizontal: 100, vertical: 50)
                            : size.width > 700
                            ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                            : null,
                        decoration: size.width > 700
                            ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                        )
                            : null,
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 30),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.asset(
                                    Images.app_logo,
                                    height: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height * 0.15 : MediaQuery.of(context).size.height / 4.5,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                  child: Text(
                                    getTranslated('Verify OTP', context),
                                    style: poppinsMedium.copyWith(fontSize: 24, color: ColorResources.getTextColor(context)),
                                  )),
                              SizedBox(height: 35),
                              Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification
                                  ? Text(
                                getTranslated('email', context),
                                style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                              )
                                  : Text(
                                getTranslated('Enter OTP', context),
                                style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                               CustomTextField(
                                hintText: getTranslated('Enter OTP', context),
                                isShowBorder: true,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.number,
                                controller: _emailController,
                                focusNode: _emailFocus,
                              ),
                              SizedBox(height: 6),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE), child: Divider(height: 1)),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  authProvider.verificationMessage.length > 0 ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5) : SizedBox.shrink(),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authProvider.verificationMessage ?? "",
                                      style: Theme.of(context).textTheme.headline2.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              // for continue button
                              SizedBox(height: 12),
                              !authProvider.isPhoneNumberVerificationButtonLoading
                                  ? CustomButton(
                                buttonText: getTranslated('continue', context),
                                onPressed: () {
                                  String _email = _emailController.text.trim();
                                  signUpController.register(
                                      context: context,
                                    otp: _email
                                  );
                                },
                              )
                                  : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                            ],
                          ),
                        ),
                      ),
                      ResponsiveHelper.isDesktop(context)
                          ? SizedBox(
                        height: 50,
                      )
                          : SizedBox(),
                      ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
