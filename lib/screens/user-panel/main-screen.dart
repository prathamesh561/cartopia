// ignore_for_file: file_names, prefer_const_constructors, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:cartopia/screens/user-panel/all-flash-sale-products.dart';
import 'package:cartopia/screens/user-panel/all-products-screen.dart';
import 'package:cartopia/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/all-products-widget.dart';
import '../../widgets/banner-widget.dart';
import '../../widgets/category-widget.dart';
import '../../widgets/custom-drawer-widget.dart';
import '../../widgets/flash-sale-widget.dart';
import '../../widgets/heading-widget.dart';
import 'all-categories-screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        showBackButton: false,
        title: "Main Screen",
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 90.0,
              ),
              //banners
              BannerWidget(),

              //heading
              HeadingWidget(
                headingTitle: "Categories",
                headingSubTitle: "According to your prefrences",
                onTap: () => Get.to(() => AllCategoriesScreen()),
              ),

              CategoriesWidget(),

              //heading
              HeadingWidget(
                headingTitle: "Flash Sale",
                headingSubTitle: "According to your prefrences",
                onTap: () => Get.to(() => AllFlashSaleProductScreen()),
              ),

              FlashSaleWidget(),

              //heading
              HeadingWidget(
                headingTitle: "All Products",
                headingSubTitle: "According to your prefrences",
                onTap: () => Get.to(() => AllProductsScreen()),
              ),

              AllProductsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
