
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/category_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/coupon_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:flutter_grocery/view/base/product_widget.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_grocery/view/base/web_product_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
class CategoryProductScreenNew extends StatefulWidget {
  final CategoryModel categoryModel;
  final String subCategoryName;
   CategoryProductScreenNew({Key key,@required this.categoryModel, this.subCategoryName}) : super(key: key);

  @override
  State<CategoryProductScreenNew> createState() => _CategoryProductScreenNewState();
}

class _CategoryProductScreenNewState extends State<CategoryProductScreenNew> {

  void _loadData(BuildContext context) async {

    if (Provider.of<CategoryProvider>(context, listen: false).categorySelectedIndex == -1) {

     Provider.of<CategoryProvider>(context, listen: false).getCategory(widget.categoryModel.id, context);

     Provider.of<CategoryProvider>(context, listen: false).getSubCategoryList(context, widget.categoryModel.id.toString(),
         Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);
     Provider.of<ProductProvider>(context, listen: false).initCategoryProductList(
       widget.categoryModel.id.toString(), context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
     );

     // Provider.of<CategoryProvider>(context, listen: false).changeSelectedIndex(-1,notify: false);
    }
  }

  @override
  void initState() {
    _loadData(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print("-----");
    String _appBarText = 'Sub Categories';
    if(widget.subCategoryName != null && widget.subCategoryName != 'null') {
      _appBarText = widget.subCategoryName;
    }else{
      _appBarText =
      Provider.of<CategoryProvider>(context).categoryModel != null
          ? Provider.of<CategoryProvider>(context).categoryModel.name : 'name';
    }
    Provider.of<ProductProvider>(context, listen: false).initializeAllSortBy(context);
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))
      : CustomAppBar(
        title: _appBarText,
        isCenter: false, isElevation: true,fromCategoryScreen: true,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(
            crossAxisAlignment: ResponsiveHelper.isDesktop(context)? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Container(height: 70,width: 1170,child: Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child){
                    return categoryProvider.subCategoryList != null ? Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      height: 32,
                      child: SizedBox(
                        width: ResponsiveHelper.isDesktop(context)? 1170 : MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT),
                                  child: InkWell(
                                    onTap: (){
                                      categoryProvider.changeSelectedIndex(-1);
                                      Provider.of<ProductProvider>(context, listen: false).initCategoryProductList(
                                        widget.categoryModel.id.toString(), context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                      );
                                    },
                                    hoverColor: Colors.transparent,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                      decoration: BoxDecoration(
                                          color: categoryProvider.categorySelectedIndex == -1 ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),
                                          borderRadius: BorderRadius.circular(7)),
                                      child: Text(
                                        getTranslated('all', context),
                                        style: poppinsRegular.copyWith(
                                          color: categoryProvider.categorySelectedIndex == -1 ? ColorResources.getBackgroundColor(context) : Colors.black ,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: categoryProvider.subCategoryList.length ,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, int index){
                                      return InkWell(
                                        onTap: (){
                                          categoryProvider.changeSelectedIndex(index);
                                          print('index: $index');

                                          Provider.of<ProductProvider>(context, listen: false).initCategoryProductList(
                                            categoryProvider.subCategoryList[index].id.toString(), context,
                                            Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                          );

                                        },
                                        hoverColor: Colors.transparent,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                          decoration: BoxDecoration(
                                              color: categoryProvider.categorySelectedIndex == index ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),
                                              borderRadius: BorderRadius.circular(7)),
                                          child: Text(
                                            categoryProvider.subCategoryList[index].name,
                                            style: poppinsRegular.copyWith(
                                              color:  categoryProvider.categorySelectedIndex == index ? ColorResources.getBackgroundColor(context) : Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ])),
                            ),
                           // if(ResponsiveHelper.isDesktop(context)) Spacer(),
                            if(ResponsiveHelper.isDesktop(context)) PopupMenuButton(
                                color: ColorResources.getWhiteColor(context),
                                elevation: 20,
                                enabled: true,
                                icon: Icon(Icons.more_vert,color: Colors.black,),
                                onSelected: (value) {
                                  int _index = Provider.of<ProductProvider>(context,listen: false).allSortBy.indexOf(value);

                                  Provider.of<ProductProvider>(context,listen: false).sortCategoryProduct(_index);
                                },

                                itemBuilder:(context) {
                                  return Provider.of<ProductProvider>(context,listen: false).allSortBy.map((choice) {
                                    return PopupMenuItem(
                                      value: choice,
                                      child: Text("$choice"),
                                    );
                                  }).toList();
                                }
                            )
                          ],
                        ),
                      ),
                    ) : subcategoryTitleShimmer();
                  }),),
              Expanded(child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    productProvider.categoryProductList.length > 0 ?
                    Container(
                      width: 1170,
                      constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: ResponsiveHelper.isDesktop(context)? (1 / 1.1) : 3,
                          crossAxisCount: ResponsiveHelper.isDesktop(context)? 5 :ResponsiveHelper.isMobilePhone()?1:ResponsiveHelper.isTab(context)?2:1,
                          mainAxisSpacing: 13,
                          crossAxisSpacing: 13,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_SMALL),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: productProvider.categoryProductList.length,
                        shrinkWrap: true,

                        itemBuilder: (BuildContext context, int index) {
                          return ProductWidget(product: productProvider.categoryProductList[index]);
                        },

                      ),
                    )  : Center(
                      child: SizedBox(
                        width: 1170,
                        child: productProvider.hasData
                            ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                          child: ProductShimmer(isEnabled: Provider.of<ProductProvider>(context).categoryProductList.length == 0),
                        )
                            : NoDataScreen(isSearch: true),
                      ),
                    ),

                    ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),

                  ],


                ),
              )),

              _cartTile(context),

            ],
          );
        }
      ),
    );
  }

  Widget _cartTile(BuildContext context) {
    bool _kmWiseCharge = Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.status == 1;
    return Consumer<CartProvider>(
        builder: (context,cartProvider,_) {
          double deliveryCharge = 0;
          (Provider.of<OrderProvider>(context).orderType == 'delivery' && !_kmWiseCharge)
              ? deliveryCharge = Provider.of<SplashProvider>(context, listen: false).configModel.deliveryCharge : deliveryCharge = 0;
          double _itemPrice = 0;
          double _discount = 0;
          double _tax = 0;
          cartProvider.cartList.forEach((cartModel) {
            _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
            _discount = _discount + (cartModel.discount * cartModel.quantity);
            _tax = _tax + (cartModel.tax * cartModel.quantity);
          });
          double _subTotal = _itemPrice + _tax;
          double _total = _subTotal - _discount - Provider.of<CouponProvider>(context).discount + deliveryCharge;
        return (cartProvider.cartList.length > 0 && ResponsiveHelper.isMobile(context)) ? Container(
          width: 1170,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              Provider.of<SplashProvider>(context, listen: false).setPageIndex(2);
            },

            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('total_item', context),
                          style: poppinsMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Theme.of(context).cardColor,
                          )),

                      Text('${cartProvider.cartList.length} ${getTranslated('items', context)}',
                          style: poppinsMedium.copyWith(color: Theme.of(context).cardColor)),

                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('total_amount', context),
                          style: poppinsMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color:Theme.of(context).cardColor,
                          )),
                      Text('${PriceConverter.convertPrice(context, _total)}',
                        style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).cardColor),
                      ),
                    ]),

                  ],
                ),
              ),
            ),
          ),
        ) : SizedBox();
      }
    );
  }
}
class subcategoryTitleShimmer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: 20),
        itemCount: 5 ,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled: true,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                    color:  Theme.of(context).textTheme.headline6.color,
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  height: 20, width: 60,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorResources.getGreyColor(context),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
class ProductShimmer extends StatelessWidget {
  final bool isEnabled;

  ProductShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : 3,
        crossAxisCount: ResponsiveHelper.isDesktop(context)? 5 : ResponsiveHelper.isMobilePhone()?1:ResponsiveHelper.isTab(context)?2:1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => ResponsiveHelper.isDesktop(context)? WebProductShimmer(isEnabled: true) : Container(
        height: 85,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorResources.getCardBgColor(context),
        ),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: isEnabled,
          child: Row(children: [

            Container(
              height: 85, width: 85,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Theme.of(context).textTheme.headline6.color),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(height: 15, width: MediaQuery.of(context).size.width, color: Theme.of(context).textTheme.headline6.color),
                  SizedBox(height: 2),
                  Container(height: 15, width: MediaQuery.of(context).size.width, color: Theme.of(context).textTheme.headline6.color),
                  SizedBox(height: 10),
                  Container(height: 10, width: 50, color: Theme.of(context).textTheme.headline6.color),
                ]),
              ),
            ),

            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(height: 15, width: 50, color: Theme.of(context).textTheme.headline6.color),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: ColorResources.getHintColor(context).withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.add, color: Theme.of(context).primaryColor),
              ),
            ]),

          ]),
        ),
      ),
      itemCount: 20,
    );
  }
}
