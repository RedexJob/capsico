import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/body/place_order_body.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/coupon_provider.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_dialog.dart';
import 'package:flutter_grocery/view/base/custom_loader.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/screens/checkout/order_successful_screen.dart';
import 'package:flutter_grocery/view/screens/checkout/widget/offline_payment_dialog.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert'as convert;

class PlaceOrderButtonView extends StatefulWidget {
  final double amount;
  final TextEditingController noteController;
  final bool kmWiseCharge;
  final String orderType;
  final double deliveryCharge;
  final bool selfPickUp;
  final String couponCode;

  PlaceOrderButtonView({
    this.amount,
    this.noteController,
    this.kmWiseCharge,
    this.orderType,
    this.deliveryCharge,
    this.selfPickUp,
    this.couponCode,
});

  @override
  State<PlaceOrderButtonView> createState() => _PlaceOrderButtonViewState();
}

class _PlaceOrderButtonViewState extends State<PlaceOrderButtonView> {

  TextEditingController paymentByController = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();
  TextEditingController paymentNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final _directPaymentList = [
      'cash_on_delivery',
      'offline_payment',
      'wallet_payment',
    ];

    return Container(
      width: 1170,
      child: Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            if(orderProvider.isLoading)
              return Center(child: CustomLoader(color: Theme.of(context).primaryColor));
            return CustomButton(
              margin: Dimensions.PADDING_SIZE_SMALL,
              buttonText: getTranslated('place_order', context),
              onPressed: () {
                if (!widget.selfPickUp && orderProvider.addressIndex == -1) {
                  showCustomSnackBar(getTranslated('select_delivery_address', context),context,isError: true);
                }else if (orderProvider.timeSlots == null || orderProvider.timeSlots.length == 0) {
                  showCustomSnackBar(getTranslated('select_a_time', context),context,isError: true);
                }else if (orderProvider.paymentMethod == '') {
                  showCustomSnackBar(getTranslated('select_payment_method', context),context,isError: true);
                } else if (!widget.selfPickUp && widget.kmWiseCharge && orderProvider.distance == -1) {
                  showCustomSnackBar(getTranslated('delivery_fee_not_set_yet', context),context,isError: true);
                }
                else {
                  List<CartModel> _cartList = Provider.of<CartProvider>(context, listen: false).cartList;
                  List<Cart> carts = [];
                  for (int index = 0; index < _cartList.length; index++) {
                    Cart cart = Cart(
                      productId: _cartList[index].id, price: _cartList[index].price, discountAmount: _cartList[index].discountedPrice,
                      quantity: _cartList[index].quantity, taxAmount: _cartList[index].tax,
                      variant: '', variation: [Variation(type: _cartList[index].variation != null ? _cartList[index].variation.type : null)],
                    );
                    carts.add(cart);
                  }

                  PlaceOrderBody _placeOrderBody = PlaceOrderBody(
                    cart: carts, orderType: widget.orderType,
                    couponCode: widget.couponCode, orderNote: widget.noteController.text,
                    branchId: _configModel.branches[orderProvider.branchIndex].id,
                    deliveryAddressId: !widget.selfPickUp
                        ? Provider.of<LocationProvider>(context, listen: false).addressList[orderProvider.addressIndex].id
                        : 0, distance: widget.selfPickUp ? 0 : orderProvider.distance,
                    couponDiscountAmount: Provider.of<CouponProvider>(context, listen: false).discount,
                    timeSlotId: orderProvider.timeSlots[orderProvider.selectTimeSlot].id,
                    paymentMethod: orderProvider.paymentMethod,
                    deliveryDate: orderProvider.getDates(context)[orderProvider.selectDateSlot],
                    couponDiscountTitle: '',
                    orderAmount: widget.amount + widget.deliveryCharge,
                  );

                  print('order Place --- \n ${_placeOrderBody.toJson()}');


                  if(_directPaymentList.contains(orderProvider.paymentMethod)) {

                    if(orderProvider.paymentMethod != 'offline_payment') {
                      if(_placeOrderBody.paymentMethod == 'cash_on_delivery'
                          && _configModel.maxAmountCodStatus &&
                          _placeOrderBody.orderAmount >
                              _configModel.maxOrderForCODAmount) {
                        showCustomSnackBar('${getTranslated('for_cod_order_must_be', context)} ${_configModel.maxOrderForCODAmount}', context);
                      }else if(orderProvider.paymentMethod == 'wallet_payment' &&
                          Provider.of<ProfileProvider>(context, listen: false).userInfoModel.walletBalance
                              < _placeOrderBody.orderAmount) {
                        showCustomSnackBar(getTranslated('wallet_balance_is_insufficient', context), context);

                      } else{
                        orderProvider.placeOrder( _placeOrderBody, _callback);
                      }
                    }else{
                      showAnimatedDialog(context, OfflinePaymentDialog(
                        placeOrderBody: _placeOrderBody,
                        callBack: (_placeOrder) => orderProvider.placeOrder( _placeOrder, _callback),
                      ), dismissible: false, isFlip: true);
                    }


                  }else{
                    String hostname = html.window.location.hostname;
                    String protocol = html.window.location.protocol;
                    String port = html.window.location.port;
                    final String _placeOrder =  convert.base64Url.encode(convert.utf8.encode(convert.jsonEncode(_placeOrderBody.toJson())));

                    String _url = "customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id}"
                        "&&callback=${AppConstants.BASE_URL}${RouteHelper.orderSuccessful}&&order_amount=${(widget.amount + widget.deliveryCharge).toStringAsFixed(2)}";

                    String _webUrl = "customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id}"
                        "&&callback=$protocol//$hostname:$port${RouteHelper.ORDER_WEB_PAYMENT}&&order_amount=${(widget.amount + widget.deliveryCharge).toStringAsFixed(2)}&&status=";

                    String _tokenUrl = convert.base64Encode(convert.utf8.encode(ResponsiveHelper.isWeb() ? _webUrl : _url));
                    String selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?token=$_tokenUrl&&payment_method=${orderProvider.paymentMethod}';

                    orderProvider.clearPlaceOrder().then((_) => orderProvider.setPlaceOrder(_placeOrder).then((value) {
                      if(ResponsiveHelper.isWeb()){
                        html.window.open(selectedUrl,"_self");
                      }else{
                        Navigator.pushReplacementNamed(context, RouteHelper.getPaymentRoute(
                          page: 'checkout',  selectAddress: _tokenUrl, placeOrderBody: _placeOrderBody,
                        ));
                      }

                    }));
                  }
                }
              },
            );
          }
      ),
    );
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if (isSuccess) {
      Provider.of<CartProvider>(Get.context, listen: false).clearCartList();
      Provider.of<OrderProvider>(Get.context, listen: false).stopLoader();
      if ( Provider.of<OrderProvider>(Get.context, listen: false).paymentMethod != 'cash_on_delivery') {
        Navigator.pushReplacementNamed(Get.context,
          '${RouteHelper.orderSuccessful+'/'}$orderID/success',
          arguments: OrderSuccessfulScreen(
            orderID: orderID, status: 0,
          ),
        );
      } else {
        Navigator.pushReplacementNamed(Get.context, '${RouteHelper.orderSuccessful}/$orderID/success');
      }
    } else {
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(content: Text(message), duration: Duration(milliseconds: 600), backgroundColor: Colors.red),);
    }
  }
}
