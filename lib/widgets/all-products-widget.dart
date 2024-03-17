// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartopia/models/cart-model.dart';
import 'package:cartopia/models/product-model.dart';
import 'package:cartopia/utils/app-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_card/image_card.dart';

import '../screens/user-panel/product-deatils-screen.dart';

class AllProductsWidget extends StatefulWidget {
  const AllProductsWidget({super.key});

  @override
  State<AllProductsWidget> createState() => _AllProductsWidgetState();
}

class _AllProductsWidgetState extends State<AllProductsWidget> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: false)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height / 5,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No products found!"),
          );
        }

        if (snapshot.data != null) {
          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              ProductModel productModel = ProductModel(
                productId: productData['productId'],
                categoryId: productData['categoryId'],
                productName: productData['productName'],
                categoryName: productData['categoryName'],
                salePrice: productData['salePrice'],
                fullPrice: productData['fullPrice'],
                amazonPrice: productData['amazonPrice'],
                flipkartPrice: productData['flipkartPrice'],
                productImages: productData['productImages'],
                deliveryTime: productData['deliveryTime'],
                isSale: productData['isSale'],
                isWishlist: productData['isWishlist'],
                productDescription: productData['productDescription'],
                createdAt: productData['createdAt'],
                updatedAt: productData['updatedAt'],
              );

              // CategoriesModel categoriesModel = CategoriesModel(
              //   categoryId: snapshot.data!.docs[index]['categoryId'],
              //   categoryImg: snapshot.data!.docs[index]['categoryImg'],
              //   categoryName: snapshot.data!.docs[index]['categoryName'],
              //   createdAt: snapshot.data!.docs[index]['createdAt'],
              //   updatedAt: snapshot.data!.docs[index]['updatedAt'],
              // );
              bool isWishlist = productModel.isWishlist;

              return Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(
                        () => ProductDetailsScreen(productModel: productModel)),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        child: Stack(
                          children: [
                            FillImageCard(
                              borderRadius: 12,
                              color: Colors.grey.withOpacity(0.1),
                              width: Get.width / 2.3,
                              heightImage: Get.height / 6,
                              imageProvider: CachedNetworkImageProvider(
                                productModel.productImages[0],
                              ),
                              title: Text(
                                productModel.productName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              description: Text(
                                "₹  " + productModel.fullPrice,
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              footer: Center(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          AppConstant.appScendoryColor)),
                                  child: Text(
                                    "Add to cart",
                                    style: GoogleFonts.poppins(
                                        color: AppConstant.appTextColor),
                                  ),
                                  onPressed: () async {
                                    await checkProductExistence(
                                        uId: user!.uid,
                                        productModel: productModel);
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                                top: 10,
                                left: 125,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.8),
                                  child: IconButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('products')
                                            .doc(productModel.productId)
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
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }

        return Container();
      },
    );
  }

  Future<void> checkProductExistence({
    required String uId,
    required ProductModel productModel,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(productModel.isSale
              ? productModel.salePrice
              : productModel.fullPrice) *
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
        productId: productModel.productId,
        categoryId: productModel.categoryId,
        productName: productModel.productName,
        categoryName: productModel.categoryName,
        salePrice: productModel.salePrice,
        fullPrice: productModel.fullPrice,
        productImages: productModel.productImages,
        deliveryTime: productModel.deliveryTime,
        isSale: productModel.isSale,
        productDescription: productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(productModel.isSale
            ? productModel.salePrice
            : productModel.fullPrice),
      );

      await documentReference.set(cartModel.toMap());

      print("product added");
    }
  }
}
