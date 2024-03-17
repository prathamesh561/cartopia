// ignore_for_file: file_names, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_print, prefer_const_declarations, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cartopia/models/product-model.dart';
import 'package:cartopia/utils/app-constant.dart';
import 'package:cartopia/widgets/app_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/cart-model.dart';
import 'cart-screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late bool isWishlist;

  @override
  void initState() {
    isWishlist = widget.productModel.isWishlist;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Product Details"),
      body: Stack(
        children: [
          Container(
            color: AppConstant.appScendoryColor,
          ),
          Container(
            height: Get.height - 180,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //product images

                  SizedBox(
                    height: Get.height / 60,
                  ),
                  CarouselSlider(
                    items: widget.productModel.productImages
                        .map(
                          (imageUrls) => ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: imageUrls,
                              fit: BoxFit.cover,
                              width: Get.width - 10,
                              height: Get.height / 2,
                              placeholder: (context, url) => ColoredBox(
                                color: Colors.white,
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      scrollDirection: Axis.horizontal,
                      autoPlay: true,
                      aspectRatio: 0.8,
                      viewportFraction: 1,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.productModel.productName,
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.8),
                                  child: IconButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('products')
                                            .doc(widget.productModel.productId)
                                            .update({
                                          'isWishlist':
                                              isWishlist ? false : true
                                        });
                                        setState(() {
                                          isWishlist = !isWishlist;
                                        });
                                      },
                                      icon: Icon(
                                        isWishlist
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                widget.productModel.isSale == true &&
                                        widget.productModel.salePrice != ''
                                    ? Text(
                                        "Price: ₹  " +
                                            widget.productModel.salePrice,
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: AppConstant.appScendoryColor,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        "Price: ₹  " +
                                            widget.productModel.fullPrice,
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: AppConstant.appScendoryColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Category: " + widget.productModel.categoryName,
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.productModel.productDescription,
                              style: GoogleFonts.poppins(
                                  fontSize: 13, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: Get.height - 150,
            left: Get.width / 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: Get.width - 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.blue[100]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: Icon(
                      Icons.chat,
                      color: AppConstant.appScendoryColor,
                    ),
                    label: Text(
                      "Chat",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppConstant.appScendoryColor),
                    ),
                    onPressed: () {
                      sendMessageOnWhatsApp(
                        productModel: widget.productModel,
                      );
                    },
                  ),
                  TextButton.icon(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: AppConstant.appScendoryColor,
                    ),
                    label: Text(
                      "Add to cart",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppConstant.appScendoryColor),
                    ),
                    onPressed: () async {
                      // Get.to(() => SignInScreen());

                      await checkProductExistence(uId: user!.uid);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Future<void> sendMessageOnWhatsApp({
    required ProductModel productModel,
  }) async {
    final number = "+918097543570";
    final message =
        "Hello Cartopia \n i want to know about this product \n ${productModel.productName} \n ${productModel.productId}";

    final url = 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //checkl prooduct exist or not

  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice) *
          updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });

      print("product exists");
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          'uId': uId,
          'createdAt': DateTime.now(),
        },
      );

      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        deliveryTime: widget.productModel.deliveryTime,
        isSale: widget.productModel.isSale,
        productDescription: widget.productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productModel.isSale
            ? widget.productModel.salePrice
            : widget.productModel.fullPrice),
      );

      await documentReference.set(cartModel.toMap());

      print("product added");
    }
  }
}
