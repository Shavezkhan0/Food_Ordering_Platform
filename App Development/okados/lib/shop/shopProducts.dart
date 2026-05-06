import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:okados/config/config.dart';
import 'package:okados/model/productModel.dart';
import 'package:okados/products/coloumAllProductsWidgets.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:http/http.dart' as http;
import 'package:okados/model/shopModel.dart' as shopModels;

class ShopProducts extends StatefulWidget {
  String? email;
  ShopProducts({Key? key, required this.email}) : super(key: key);

  @override
  State<ShopProducts> createState() => _ShopProductsState();
}

class _ShopProductsState extends State<ShopProducts> {
  List<shopModels.Shop> _shopsData = [];
  List<ProductModel> _allProducts = [];
  @override
  void initState() {
    super.initState();
    // Print email in initState for debugging
    getShopDetails();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Restaurent",
          style: TextStyle(color: whiteColor),
        ),
        iconTheme: const IconThemeData(
          color: whiteColor,
        ),
        centerTitle: true,
        elevation: 4.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBackgroundColor, whiteColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _shopsData.isNotEmpty ? RestaurentDetails() : SizedBox.shrink(),
              _allProducts.isNotEmpty
                  ? ColoumAllProductsWidgets(
                      title: "",
                      products: _allProducts,
                    )
                  : SizedBox.shrink()
            ],
          ),
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10), // Rounded corners at the top
              ),
              child: Container(
                color: whiteColor,
                height: 210,
                width: double.infinity,
                child: Image.network(
                  _shopsData[0].image[0].secureUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
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

  Future<void> getShopDetails() async {
    if (widget.email == null || widget.email!.isEmpty) {
      showSnackBar(context, "Shop Details can't fetch");
      return;
    }
    try {
      final response =
          await http.get(Uri.parse('$shopDetailsApi?email=${widget.email}'));
      var data = jsonDecode(response.body);

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

  Future<void> getProducts() async {
    if (widget.email == null || widget.email!.isEmpty) {
      showSnackBar(context, "Shop Details can't fetch");
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          "$shopAllProducts?email=${widget.email}&limit=5&skip=${_allProducts.length}"));
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey('Products')) {
        List<dynamic> productsData = data['Products'];

        List<ProductModel> allProducts =
            productsData.map((json) => ProductModel.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            _allProducts.addAll(allProducts);
          });
        }
      } else {
        throw Exception('Failed to load shops');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
