import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_grocery/view/screens/menu/main_screen.dart';
import 'package:flutter_grocery/view/screens/menu/web_menu/menu_screen_web.dart';
import 'package:flutter_grocery/view/screens/menu/widget/custom_drawer.dart';
import 'package:flutter_grocery/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_grocery/view/screens/notification/notification_screen.dart';
import 'package:flutter_grocery/view/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CustomDrawerController _drawerController = CustomDrawerController();

  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    Provider.of<LocationProvider>(context, listen: false)
        .initAddressList(context);
    super.initState();
    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {

    } else {

    }
    //Provider.of<CartProvider>(context, listen: false).getCartData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawer(
      controller: _drawerController,
      menuScreen: MenuWidget(drawerController: _drawerController),
      mainScreen: MainScreen(drawerController: _drawerController),
      showShadow: false,
      angle: 0.0,
      borderRadius: 30,
      slideWidth: MediaQuery.of(context).size.width *
          (CustomDrawer.isRTL(context) ? 0.45 : 0.70),
    );
  }
}

class MenuWidget extends StatelessWidget {
  final CustomDrawerController drawerController;

  MenuWidget({this.drawerController});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final _screenList = screenList;

    return WillPopScope(
      onWillPop: () async {
        if (drawerController.isOpen()) {
          drawerController.toggle();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
            ? ColorResources.getBackgroundColor(context)
            : ResponsiveHelper.isDesktop(context)
                ? ColorResources.getBackgroundColor(context)
                : ColorResources.GREEN_COL0RDart,

        //backgroundColor: Color(0xff051b85f),
        appBar: ResponsiveHelper.isDesktop(context)
            ? PreferredSize(
                child: WebAppBar(), preferredSize: Size.fromHeight(120))
            : null,
        body: SafeArea(
          child: ResponsiveHelper.isDesktop(context)
              ? MenuScreenWeb(isLoggedIn: _isLoggedIn)
              : SingleChildScrollView(
                  child: Center(
                    child: Container(
                      width: 1170,
                      child: Consumer<SplashProvider>(
                        builder: (context, splash, child) {
                          return Column(children: [
                            !ResponsiveHelper.isDesktop(context)
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      icon: Icon(Icons.close,
                                          color: Provider.of<ThemeProvider>(
                                                      context)
                                                  .darkTheme
                                              ? ColorResources.getTextColor(
                                                  context)
                                              : ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? ColorResources
                                                      .getBackgroundColor(
                                                          context)
                                                  : ColorResources
                                                      .getBackgroundColor(
                                                          context)),
                                      onPressed: () =>
                                          drawerController.toggle(),
                                    ),
                                  )
                                : SizedBox(),
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) => Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            RouteHelper.profile,
                                            arguments: ProfileScreen());
                                      },
                                      leading: ClipOval(
                                        child: _isLoggedIn
                                            ? Provider.of<SplashProvider>(
                                                            context,
                                                            listen: false)
                                                        .baseUrls !=
                                                    null
                                                ? Builder(builder: (context) {
                                                    return FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          Images.placeholder(
                                                              context),
                                                      image:
                                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                                                          '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
                                                      height: 50,
                                                      width: 50,
                                                      fit: BoxFit.cover,
                                                      imageErrorBuilder: (c, o,
                                                              s) =>
                                                          Image.asset(
                                                              Images
                                                                  .placeholder(
                                                                      context),
                                                              height: 50,
                                                              width: 50,
                                                              fit:
                                                                  BoxFit.cover),
                                                    );
                                                  })
                                                : SizedBox()
                                            : Image.asset(
                                                Images.placeholder(context),
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.cover),
                                      ),
                                      title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _isLoggedIn
                                                ? profileProvider
                                                            .userInfoModel !=
                                                        null
                                                    ? Text(
                                                        '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                                        style: poppinsRegular
                                                            .copyWith(
                                                          color: Provider.of<
                                                                          ThemeProvider>(
                                                                      context)
                                                                  .darkTheme
                                                              ? ColorResources
                                                                  .getTextColor(
                                                                      context)
                                                              : ResponsiveHelper.isDesktop(
                                                                      context)
                                                                  ? ColorResources
                                                                      .getDarkColor(
                                                                          context)
                                                                  : ColorResources
                                                                      .getBackgroundColor(
                                                                          context),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 10,
                                                        width: 150,
                                                        color:
                                                            ResponsiveHelper
                                                                    .isDesktop(
                                                                        context)
                                                                ? ColorResources
                                                                    .getDarkColor(
                                                                        context)
                                                                : ColorResources
                                                                    .getBackgroundColor(
                                                                        context))
                                                : Text(
                                                    getTranslated(
                                                        'guest', context),
                                                    style:
                                                        poppinsRegular.copyWith(
                                                      color: Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .darkTheme
                                                          ? ColorResources.getTextColor(
                                                              context)
                                                          : ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? ColorResources
                                                                  .getDarkColor(
                                                                      context)
                                                              : ColorResources
                                                                  .getBackgroundColor(
                                                                      context),
                                                    ),
                                                  ),
                                            _isLoggedIn
                                                ? profileProvider
                                                            .userInfoModel !=
                                                        null
                                                    ? Text(
                                                        '${profileProvider.userInfoModel.phone ?? ''}',
                                                        style: poppinsRegular
                                                            .copyWith(
                                                          color: Provider.of<
                                                                          ThemeProvider>(
                                                                      context)
                                                                  .darkTheme
                                                              ? ColorResources
                                                                  .getTextColor(
                                                                      context)
                                                              : ResponsiveHelper.isDesktop(
                                                                      context)
                                                                  ? ColorResources
                                                                      .getDarkColor(
                                                                          context)
                                                                  : ColorResources
                                                                      .getBackgroundColor(
                                                                          context),
                                                        ))
                                                    : Container(
                                                        height: 10,
                                                        width: 100,
                                                        color:
                                                            ResponsiveHelper
                                                                    .isDesktop(
                                                                        context)
                                                                ? ColorResources
                                                                    .getDarkColor(
                                                                        context)
                                                                : ColorResources
                                                                    .getBackgroundColor(
                                                                        context))
                                                : Text(
                                                    '0123456789',
                                                    style:
                                                        poppinsRegular.copyWith(
                                                      color: Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .darkTheme
                                                          ? ColorResources.getTextColor(
                                                              context)
                                                          : ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? ColorResources
                                                                  .getDarkColor(
                                                                      context)
                                                              : ColorResources
                                                                  .getBackgroundColor(
                                                                      context),
                                                    ),
                                                  ),
                                          ]),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.notifications,
                                        color:
                                            Provider.of<ThemeProvider>(context)
                                                    .darkTheme
                                                ? ColorResources.getTextColor(
                                                    context)
                                                : ResponsiveHelper.isDesktop(
                                                        context)
                                                    ? ColorResources
                                                        .getDarkColor(context)
                                                    : ColorResources
                                                        .getBackgroundColor(
                                                            context)),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, RouteHelper.notification,
                                          arguments: NotificationScreen());
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 50),
                            if (!ResponsiveHelper.isDesktop(context))
                              Column(
                                  children: _screenList
                                      .map((model) => ListTile(
                                            onTap: () {
                                              if (!ResponsiveHelper.isDesktop(
                                                  context)) {
                                                splash.setPageIndex(
                                                    _screenList.indexOf(model));
                                                print(
                                                    'page index -- ${splash.pageIndex}');
                                              }

                                              if (splash.pageIndex == 0) {
                                                splash.getsidBarClickTrue(true);
                                              } else {
                                                splash
                                                    .getsidBarClickTrue(false);
                                              }

                                              //Navigator.pushNamed(context, model.routeName);
                                              drawerController.toggle();
                                            },
                                            selected: splash.pageIndex ==
                                                _screenList.indexOf(model),
                                            selectedTileColor:
                                                Colors.black.withAlpha(30),
                                            leading: Image.asset(
                                              model.icon,
                                              color: ResponsiveHelper
                                                      .isDesktop(context)
                                                  ? ColorResources.getDarkColor(
                                                      context)
                                                  : Colors.white,
                                              width: 25,
                                              height: 25,
                                            ),
                                            title: Text(
                                                getTranslated(
                                                    model.title, context),
                                                style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE,
                                                  color: Provider.of<
                                                                  ThemeProvider>(
                                                              context)
                                                          .darkTheme
                                                      ? ColorResources
                                                          .getTextColor(context)
                                                      : ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? ColorResources
                                                              .getDarkColor(
                                                                  context)
                                                          : ColorResources
                                                              .getBackgroundColor(
                                                                  context),
                                                )),
                                          ))
                                      .toList()),
                            ListTile(
                              onTap: () {
                                if (_isLoggedIn) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) =>
                                          SignOutConfirmationDialog());
                                } else {
                                  Provider.of<SplashProvider>(context,
                                          listen: false)
                                      .setPageIndex(0);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteHelper.getLoginRoute(),
                                      (route) => false);
                                }
                              },
                              leading: Image.asset(
                                _isLoggedIn ? Images.log_out : Images.app_logo,
                                color: ResponsiveHelper.isDesktop(context)
                                    ? ColorResources.getDarkColor(context)
                                    : Colors.white,
                                width: 25,
                                height: 25,
                              ),
                              title: Text(
                                getTranslated(
                                    _isLoggedIn ? 'log_out' : 'login', context),
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Provider.of<ThemeProvider>(context)
                                          .darkTheme
                                      ? ColorResources.getTextColor(context)
                                      : ResponsiveHelper.isDesktop(context)
                                          ? ColorResources.getDarkColor(context)
                                          : ColorResources.getBackgroundColor(
                                              context),
                                ),
                              ),
                            ),
                          ]);
                        },
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class MenuButton {
  final String routeName;
  final String icon;
  final String title;
  final IconData iconData;

  MenuButton(
      {@required this.routeName,
      @required this.icon,
      @required this.title,
      this.iconData = null});
}
