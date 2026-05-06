import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:okados/cache_Manager_Image/cache_manager_image.dart';
import 'package:okados/cart/cart_provider.dart';
import 'package:okados/config/config.dart';
import 'package:okados/dataBase/db_helper.dart';
import 'package:okados/model/cart.dart';
import 'package:okados/model/productModel.dart';
import 'package:okados/products/ProductsWidget.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:provider/provider.dart';
import 'package:okados/model/cart.dart' as cartModel;

class ColoumAllProductsWidgets extends StatefulWidget {
  final String title;
  final List<ProductModel> products;
  ColoumAllProductsWidgets({
    Key? key,
    required this.title,
    required this.products,
  }) : super(key: key);

  @override
  State<ColoumAllProductsWidgets> createState() =>
      _ColoumAllProductsWidgetsState();
}

class _ColoumAllProductsWidgetsState extends State<ColoumAllProductsWidgets> {
  DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    bool isLoading = widget.products.isEmpty;
    final cart = Provider.of<CartProvider>(context);

    return Column(
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        Container(
          width: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              final product = widget.products[index];
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 15.0),
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
                  child: Card(
                    elevation: 10, // Elevation for shadow effect
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10)), // Rounded corners
                    ),
                    child: Container(
                      height: 295,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                        color: whiteColor, // Replace with your color variable
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)), // Matches Card's shape
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(
                                    10), // Rounded corners at the top
                              ),
                              child: Container(
                                color: whiteColor,
                                height: 210,
                                width: double.infinity,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  margin: const EdgeInsets.only(left: 8),
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
                                            "Restaurent: ",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              product.shopname.toString(),
                                              overflow: TextOverflow.ellipsis,
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
                                  height: 80,
                                  margin: const EdgeInsets.only(right: 8),
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
                                            description: product.description,
                                            imagesInfo: product?.imagesInfo
                                                ?.map((image) =>
                                                    cartModel.ImageModel(
                                                      publicId: image.publicId,
                                                      secureUrl:
                                                          image.secureUrl,
                                                      sId: image.sId,
                                                    ))
                                                .toList(),
                                            category: product.category,
                                            foodCategory: product.foodCategory,
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
                                                size: 20, color: primaryColor),
                                            Text(
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
