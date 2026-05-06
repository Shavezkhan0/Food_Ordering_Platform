import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:okados/config/config.dart';
import 'package:okados/model/productModel.dart';
import 'package:http/http.dart' as http;
import 'package:okados/products/coloumAllProductsWidgets.dart';

class SingleCategoryProductsWidget extends StatefulWidget {
  final String title;

  const SingleCategoryProductsWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<SingleCategoryProductsWidget> createState() =>
      _SingleTypeProductsWidgetState();
}

class _SingleTypeProductsWidgetState
    extends State<SingleCategoryProductsWidget> {
  List<ProductModel> _allProducts = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingProduct = false;
  String api = "";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getApi();
    getProducts();
  }

  getApi() async {
    if (widget.title == "Momo") {
      api = momoApi;
    } else if (widget.title == "Chowmein") {
      api = chowmeinApi;
    } else if (widget.title == "Pizza") {
      api = pizzaApi;
    } else if (widget.title == "Burger") {
      api = burgerApi;
    } else if (widget.title == "Fries") {
      api = friesApi;
    } else if (widget.title == "Noodles") {
      api = noodlesApi;
    } else if (widget.title == "Shawarma") {
      api = shawarmaApi;
    } else if (widget.title == "Roll") {
      api = rollApi;
    } else if (widget.title == "Biryani") {
      api = biryaniApi;
    } else if (widget.title == "Nihari") {
      api = nihariApi;
    } else if (widget.title == "Tikka") {
      api = tikkaApi;
    } else if (widget.title == "Korma") {
      api = kormaApi;
    } else if (widget.title == "Chicken Fry") {
      api = chickenfryApiApi;
    } else if (widget.title == "Roti") {
      api = rotiApi;
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print("bottom");
      getProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
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
          controller: _scrollController,
          child: Column(
            children: [
              _isLoadingProduct
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ColoumAllProductsWidgets(title: "", products: _allProducts),
              !_isLoadingProduct
                  ? Center(
                      child: Container(
                        child: Center(child: Text("Loading more ...")),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getProducts() async {
    setState(() {
      // _isLoadingProduct = true;
    });
    try {
      final response =
          await http.get(Uri.parse('$api?limit=5&skip=${_allProducts.length}'));
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
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          // _isLoadingProduct = false;
        });
      }
    }
  }
}
