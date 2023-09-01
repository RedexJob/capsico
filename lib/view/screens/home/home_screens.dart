import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/config_model.dart';
import 'package:flutter_grocery/helper/product_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/banner_provider.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/flash_deal_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/wishlist_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/title_row.dart';
import 'package:flutter_grocery/view/base/title_widget.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_grocery/view/screens/home/widget/banners_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/category_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/home_item_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/product_view.dart';
import 'package:flutter_grocery/view/screens/home_items_screen/widget/flash_deals_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static Future<void> loadData(bool reload, BuildContext context) async {
    ConfigModel config = Provider.of<SplashProvider>(context, listen: false).configModel;
    if(reload) {
      Provider.of<SplashProvider>(context, listen: false).initConfig(context);
    }
    Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
      context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,reload,
    );

    Provider.of<BannerProvider>(context, listen: false).getBannerList(context, reload);

    await Provider.of<ProductProvider>(context, listen: false).getItemList(
      context,'1', true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      ProductType.DAILY_ITEM,
    );

    if(config.mostReviewedProductStatus) {
      await Provider.of<ProductProvider>(context, listen: false).getItemList(
        context,'1', true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
        ProductType.MOST_REVIEWED,
      );
    }

    if(config.featuredProductStatus) {
      await Provider.of<ProductProvider>(context, listen: false).getItemList(
        context,'1', true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
        ProductType.FEATURED_ITEM,
      );
    }
    if(config.trendingProductStatus) {
      await Provider.of<ProductProvider>(context, listen: false).getItemList(
        context,'1', true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
        ProductType.TRENDING_PRODUCT,
      );
    }

    if(config.recommendedProductStatus) {
      await Provider.of<ProductProvider>(context, listen: false).getItemList(
        context,'1', true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
        ProductType.RECOMMEND_PRODUCT,
      );
    }

    await Provider.of<ProductProvider>(context, listen: false).getItemList(
      context,'1', true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      ProductType.POPULAR_PRODUCT,
    );

    await Provider.of<ProductProvider>(context, listen: false).getLatestProductList(
      context,'1', true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
    if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<WishListProvider>(context, listen: false).getWishList(context);
    }

    if(config.flashDealProductStatus) {

      await Provider.of<FlashDealProvider>(context, listen: false).getFlashDealList(true, context, false);
    }

  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Consumer<SplashProvider>(builder: (context, splashProvider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            Provider.of<ProductProvider>(context, listen: false).offset = 1;
            Provider.of<ProductProvider>(context, listen: false).popularOffset = 1;
            await HomeScreen.loadData(true, context);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Scaffold(
            appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))  : null,
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(children: [
                Center(child: SizedBox(
                  width: 1170,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: ResponsiveHelper.isDesktop(context)
                          ? MediaQuery.of(context).size.height - 400
                          : MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                        children: [

                          Consumer<BannerProvider>(builder: (context, banner, child) {
                            return banner.bannerList == null ? BannersView() : banner.bannerList.length == 0 ? SizedBox() : BannersView();
                          }),

                          // Category
                          Consumer<CategoryProvider>(builder: (context, category, child) {
                            return category.categoryList == null ? CategoryView() : category.categoryList.length == 0 ? SizedBox() : CategoryView();
                          }),

                          // Category
                          SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL),

                          if(splashProvider.configModel.flashDealProductStatus)
                            Consumer<FlashDealProvider>(builder: (context, flashDeal, child) {
                              return TitleRow(
                                isDetailsPage: false,
                                title: getTranslated('flash_deal', context),
                                eventDuration: flashDeal.flashDeal != null
                                    ? flashDeal.duration : null,
                                onTap: () => Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.FLASH_SALE)),

                              );
                            },
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                        if(splashProvider.configModel.flashDealProductStatus)
                          Consumer<FlashDealProvider>(builder: (context, flashDealProvider, child) {
                            return !ResponsiveHelper.isDesktop(context) ?
                            Container(
                              height: MediaQuery.of(context).size.width *.77,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
                                child: FlashDealsView(isHomeScreen: true),
                              ),
                            ) : HomeItemView(productList: flashDealProvider.flashDealList);
                            },
                          ),

                          TitleWidget(title: getTranslated('daily_needs', context) ,onTap: () {
                            Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.DAILY_ITEM));
                          }),

                          Consumer<ProductProvider>(builder: (context, productProvider, child) {
                            return productProvider.dailyItemList == null ? HomeItemView(productList: productProvider.dailyItemList) : productProvider.dailyItemList.length == 0
                                ? SizedBox() : HomeItemView(productList: productProvider.dailyItemList);
                          }),

                          if(splashProvider.configModel.featuredProductStatus) Column(children: [
                            TitleWidget(title: getTranslated(ProductType.FEATURED_ITEM, context) ,onTap: () {
                              Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.FEATURED_ITEM));
                            }),

                            Consumer<ProductProvider>(builder: (context, productProvider, child) {
                              return productProvider.featuredProductList == null
                                  ? HomeItemView(productList: productProvider.featuredProductList)
                                  : productProvider.featuredProductList.length == 0 ? SizedBox()
                                  : HomeItemView(productList: productProvider.featuredProductList);
                            }),
                          ]),

                          if(splashProvider.configModel.mostReviewedProductStatus) Column(children: [
                            TitleWidget(title: getTranslated(ProductType.MOST_REVIEWED, context) ,onTap: () {
                              Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.MOST_REVIEWED));
                            }),

                            Consumer<ProductProvider>(builder: (context, productProvider, child) {
                              return productProvider.mostViewedProductList == null
                                  ? HomeItemView(productList: productProvider.mostViewedProductList)
                                  : productProvider.mostViewedProductList.length == 0 ? SizedBox()
                                  : HomeItemView(productList: productProvider.mostViewedProductList);
                            }),
                          ]),

                          if(splashProvider.configModel.trendingProductStatus) Column(children: [
                            TitleWidget(title: getTranslated(ProductType.TRENDING_PRODUCT, context) ,onTap: () {
                              Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.TRENDING_PRODUCT));
                            }),

                            Consumer<ProductProvider>(builder: (context, productProvider, child) {
                              return productProvider.trendingProduct == null
                                  ? HomeItemView(productList: productProvider.trendingProduct)
                                  : productProvider.trendingProduct.length == 0 ? SizedBox()
                                  : HomeItemView(productList: productProvider.trendingProduct);
                            }),

                          ]),


                          if(splashProvider.configModel.recommendedProductStatus) Column(children: [
                            TitleWidget(title: getTranslated(ProductType.RECOMMEND_PRODUCT, context) ,onTap: () {
                              Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.RECOMMEND_PRODUCT));
                            }),

                            Consumer<ProductProvider>(builder: (context, productProvider, child) {
                              return productProvider.recommendProduct == null
                                  ? HomeItemView(productList: productProvider.recommendProduct)
                                  : productProvider.recommendProduct.length == 0 ? SizedBox()
                                  : HomeItemView(productList: productProvider.recommendProduct);
                            }),

                          ]),


                          TitleWidget(title: getTranslated(ProductType.POPULAR_PRODUCT, context) ,onTap: () {
                            Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.POPULAR_PRODUCT));
                          }),

                          Consumer<ProductProvider>(builder: (context, productProvider, child) {
                            return productProvider.latestProductList == null ? HomeItemView(productList: productProvider.latestProductList) : productProvider.latestProductList.length == 0
                                ? SizedBox() : HomeItemView(productList: productProvider.latestProductList);
                          }),


                          ResponsiveHelper.isMobilePhone() ? SizedBox(height: 10) : SizedBox.shrink(),
                          TitleWidget(title: getTranslated('latest_items', context)),
                          ProductView(scrollController: _scrollController),


                        ]),
                  ),
                )),

                ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),

              ]),
            ),
          ),
        );
      }
    );
  }
}
