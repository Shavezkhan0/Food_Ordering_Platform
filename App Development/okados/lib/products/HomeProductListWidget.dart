import 'dart:math';

import 'package:flutter/material.dart';
import 'package:okados/cache_Manager_Image/cache_manager_image.dart';
import 'package:okados/cart/cart_provider.dart';
import 'package:okados/config/config.dart';
import 'package:okados/dataBase/db_helper.dart';
import 'package:okados/model/cart.dart';
import 'package:okados/model/productModel.dart';
import 'package:okados/products/ProductsWidget.dart';
import 'package:okados/products/SingleCategoryProductsWidget.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:okados/model/cart.dart' as cartModel;

class HomeProductListWidget extends StatefulWidget {
  final String title;
  final List<ProductModel> products;

  const HomeProductListWidget({
    Key? key,
    required this.title,
    required this.products,
  }) : super(key: key);

  @override
  State<HomeProductListWidget> createState() => _HomeProductListWidgetState();
}

class _HomeProductListWidgetState extends State<HomeProductListWidget> {
  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    bool isLoading = widget.products.isEmpty;

    final cart = Provider.of<CartProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: blackColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 55,
                    height: 25,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SingleCategoryProductsWidget(
                                        title: widget.title,
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3, vertical: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: whiteColor,
                          textStyle: const TextStyle(
                              color: primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                        child: const Text(
                          "All",
                        )),
                  )),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: isLoading
                  ? List.generate(
                      5,
                      (index) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 340,
                          height: 300,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                  : widget.products.map((product) {
                      return Card(
                        // elevation: 15,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            showSnackBar(context, "${product.sId}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductWidget(
                                          id: product.sId,
                                        )));
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                height: 220,
                                width: 340,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: product.imagesInfo![0].secureUrl
                                        .toString(),
                                    fit: BoxFit.cover,
                                    cacheManager: CustomCacheManager.instance,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/placeholder.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 220,
                                      height: 80,
                                      margin: const EdgeInsets.only(left: 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            product.description.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Restaurent : ",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  product.shopname.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.currency_rupee,
                                                size: 15,
                                                color: greenColor,
                                              ),
                                              Text(
                                                product.price.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: greenColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // height: 80,
                                      margin: const EdgeInsets.only(right: 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: primaryColor,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.yellow),
                                            ),
                                            onPressed: () {
                                              dbHelper
                                                  .insert(Cart(
                                                sId: product.sId,
                                                title: product.title,
                                                shop: product.shop,
                                                active: product.active,
                                                shopname: product.shopname,
                                                email: product.email,
                                                description:
                                                    product.description,
                                                imagesInfo: product?.imagesInfo
                                                    ?.map((image) =>
                                                        cartModel.ImageModel(
                                                          publicId:
                                                              image.publicId,
                                                          secureUrl:
                                                              image.secureUrl,
                                                          sId: image.sId,
                                                        ))
                                                    .toList(),
                                                category: product.category,
                                                foodCategory:
                                                    product.foodCategory,
                                                price: product.price,
                                                quantity: 1,
                                              ))
                                                  .then((value) {
                                                cart.addTotalPrice(double.parse(
                                                    product.price.toString()));
                                                cart.addCounter();
                                                showSnackBar(
                                                    context, "Added To Card");
                                              }).onError((error, stackTrace) {
                                                print(error.toString());
                                              });
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(Icons.shopping_cart,
                                                    size: 20,
                                                    color: primaryColor),
                                                const Text(
                                                  "Add",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
