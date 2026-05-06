import 'package:flutter/material.dart';
import 'package:okados/config/config.dart';
import 'package:okados/model/productModel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget AllProductsWidget(List<ProductModel> allProducts) {
  bool isLoading = allProducts.isEmpty;

  return Container(
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
                "All Products",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 30,
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: isLoading
                ? List.generate(
                    5, // Number of shimmer cards
                    (index) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 300,
                        height: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                : allProducts.map((product) {
                    return Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: blackColor, width: 2),
                      ),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white54,
                            height: 200,
                            width: 340,
                            child: CachedNetworkImage(
                              imageUrl:
                                  product.imagesInfo![0].secureUrl.toString(),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            color: whiteColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 220,
                                  height: 100,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        product.description.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.currency_rupee,
                                            size: 18,
                                            color: greenColor,
                                          ),
                                          Text(
                                            product.price.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: greenColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  // width: 100,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.star, color: primaryColor),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.yellow),
                                        ),
                                        onPressed: () {},
                                        child: Row(
                                          children: [
                                            Icon(Icons.shopping_cart,
                                                color: primaryColor),
                                            const Text(
                                              "Add",
                                              style: TextStyle(
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
                    );
                  }).toList(),
          ),
        ),
      ],
    ),
  );
}
