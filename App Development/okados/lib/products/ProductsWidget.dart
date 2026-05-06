import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okados/cart/cartPage.dart';
import 'package:okados/cart/cart_provider.dart';
import 'package:okados/config/config.dart';
import 'package:okados/dataBase/db_helper.dart';
import 'package:okados/model/cart.dart' as cartModel;
import 'package:okados/model/productModel.dart';
import 'package:okados/model/shopModel.dart' as shopModels;
import 'package:okados/order/orderAddress.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:okados/model/cart.dart';

class ProductWidget extends StatefulWidget {
  final String? id;
  const ProductWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  List<shopModels.Shop> _shopsData = [];
  ProductModel? _product;
  int quantity = 1;
  DBHelper dbHelper = DBHelper();

  bool isLoading = false;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    setState(() => isLoading = true);
    await getProduct();
    if (mounted) await getShopDetails();
    if (mounted) setState(() => isLoading = false);
  }

  // @override
  // void dispose() {
  //   print("dispose: ProductsWidget");
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return isLoading
        ? Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [primaryColor, whiteColor])),
            child: const SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: CircularProgressIndicator(
                  color: whiteColor,
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                _product!.title.toString() ?? ".....",
                style: TextStyle(color: whiteColor),
              ),
              iconTheme: const IconThemeData(
                color: whiteColor,
              ),
              centerTitle: true,
              elevation: 4.0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
              ),
            ),
            body: _product == null
                ? Center(
                    child: Text("No Product Data Found"),
                  )
                : Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryBackgroundColor, whiteColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ProductDetails(),
                          Quantity(),
                          _shopsData.isEmpty
                              ? Container(
                                  child: CircularProgressIndicator(),
                                )
                              : RestaurentDetails(),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      dbHelper
                          .insert(Cart(
                        sId: _product?.sId,
                        title: _product?.title,
                        shop: _product?.shop,
                        active: _product?.active,
                        shopname: _product?.shopname,
                        email: _product?.email,
                        description: _product?.description,
                        imagesInfo: _product?.imagesInfo
                            ?.map((image) => cartModel.ImageModel(
                                  publicId: image.publicId,
                                  secureUrl: image.secureUrl,
                                  sId: image.sId,
                                ))
                            .toList(),
                        category: _product?.category,
                        foodCategory: _product?.foodCategory,
                        price: _product?.price,
                        quantity: quantity,
                      ))
                          .then((value) {
                        cart.addTotalPrice(
                            double.parse(_product!.price.toString()) *
                                quantity);
                        cart.addCounter();
                        showSnackBar(context, "Added To Card");
                      }).onError((error, stackTrace) {
                        print(error.toString());
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width *
                            0.12, // 10% of screen width
                        vertical: 10, // Fixed vertical padding
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: yellowColor, // Ensure this is defined
                    ),
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ),
                      );
                      showSnackBar(context, "Next");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width *
                            0.18, // 10% of screen width
                        vertical: 10, // Fixed vertical padding
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor:
                          secondaryBackgroundColor, // Ensure this is defined
                    ),
                    child: const Text(
                      "Cart",
                      style: TextStyle(
                          fontSize: 16,
                          color: whiteColor), // Ensure whiteColor is defined
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget ProductDetails() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _product?.imagesInfo?.length ?? 0,
              itemBuilder: (context, index) {
                return Image.network(
                  _product!.imagesInfo![index].secureUrl.toString(),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: _product!.imagesInfo!.length,
            effect: const ExpandingDotsEffect(
              activeDotColor: secondaryColor,
              dotColor: primaryBackgroundColor,
              dotHeight: 8,
              dotWidth: 8,
              spacing: 8,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            color: grayColor,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(_product!.title!.toString() ?? "Loading...",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    )),
                Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.currency_rupee,
                          size: 18,
                          color: greenColor,
                        ),
                        Text(
                          _product!.price.toString() ?? "No price",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: greenColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        width:
                            10), // Reduced space between first pair and second pair
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.currency_rupee_sharp,
                          size: 15,
                          color: Colors.grey,
                        ),
                        Text(
                          (_product!.price! * 1.1).toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Description: ",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        )),
                    Text(
                      _product!.description.toString() ?? "No Description",
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("FoodCategory : ",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        )),
                    Text(
                      _product!.foodCategory.toString() ?? "No Description",
                    ),
                    _product!.foodCategory.toString() == "nonVeg"
                        ? Icon(
                            Icons.square,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.eco,
                            color: Colors.green,
                          ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget Quantity() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Quantity : ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    )),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                      icon: Icon(Icons.remove),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(quantity.toString()),
                    SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget RestaurentDetails() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Rextaurent Details : ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                Icon(
                  Icons.restaurant,
                  color: primaryColor,
                  size: 18,
                )
              ],
            ),
            Row(
              children: [
                Text("Restaurent Name : ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    )),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    _shopsData[0].username.toString() ?? "No Name",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text("Address  ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    )),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    _shopsData[0].address.toString() ?? "No Address",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text("Landmark : ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    )),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    _shopsData[0].landmark.toString() ?? "No Address",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text("City : ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    )),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    _shopsData[0].city.toString() ?? "No Address",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text("State : ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    )),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    _shopsData[0].state.toString() ?? "No Address",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getProduct() async {
    if (widget.id == null || widget.id!.isEmpty) {
      showSnackBar(context, "Invalid product ID.");
      setState(() => isLoading = false);
      return;
    }

    try {
      final response =
          await http.get(Uri.parse('$search_by_idApi?id=${widget.id}'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null &&
            data.containsKey('Products') &&
            data['Products'].isNotEmpty) {
          setState(() => _product = ProductModel.fromJson(data['Products']));
        } else {
          showSnackBar(context, "No products found.");
        }
      } else {
        showSnackBar(context, "Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching product: $e");
      showSnackBar(context, "Error: ${e.toString()}");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> getShopDetails() async {
    if (_product == null ||
        _product!.email == null ||
        _product!.email!.isEmpty) {
      showSnackBar(context, "Shop Details can't fetch");
      return;
    }

    try {
      final response =
          await http.get(Uri.parse('$shopDetailsApi?email=${_product!.email}'));
      var data = jsonDecode(response.body);

      print(response.body);
      if (response.statusCode == 200 && data.containsKey('shop')) {
        List<dynamic> shopsData = data['shop'];

        List<shopModels.Shop> shops =
            shopsData.map((json) => shopModels.Shop.fromJson(json)).toList();
        if (mounted) {
          setState(() {
            _shopsData = shops;
          });
        }
      } else {
        throw Exception('Failed to load AllProducts');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
