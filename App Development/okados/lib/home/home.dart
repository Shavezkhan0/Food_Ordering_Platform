import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:okados/config/config.dart';
import 'package:okados/dashboard/dashboard.dart';
import 'package:okados/model/productModel.dart';
import 'package:okados/model/shopModel.dart' as shopModels;
import 'package:okados/model/user.dart';
import 'package:okados/products/SingleCategoryProductsWidget.dart';
import 'package:okados/products/coloumAllProductsWidgets.dart';
import 'package:okados/products/allProducts.dart';
import 'package:okados/products/HomeProductListWidget.dart';
import 'package:okados/shop/shopProducts.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModel? _user;
  List<shopModels.Shop> _shopsData = [];
  List<ProductModel> _momo = [];
  List<ProductModel> _chowmein = [];
  List<ProductModel> _fries = [];
  List<ProductModel> _biryani = [];
  List<ProductModel> _pizza = [];
  List<ProductModel> _burger = [];
  List<ProductModel> _shawarma = [];
  List<ProductModel> _allProducts = [];

  bool isLoadingProduct = false;
  bool isLoading = true;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _imagePaths = [
    'assets/images/front/1.jpg',
    'assets/images/front/2.jpg',
    'assets/images/front/3.jpg',
    'assets/images/front/4.jpg',
    'assets/images/front/5.jpeg',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserData();
    getShopsData();
    getMomo();
    _scrollController.addListener(_scrollListener);

    getChowmein();
    getFries();

    getBiryani();
    getPizza();

    getBurger();
    getshawarma();

    getAllProducts();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print("bottom");
      getAllProducts();
    }
  }

  @override
  void dispose() {
    print("dispose: Home");
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('User');
    setState(() {
      isLoading = true;
    });

    if (userString != null) {
      // Decode the JSON string back into a UserModel
      final userJson = jsonDecode(userString);
      if (mounted) {
        // Ensure the widget is still mounted before calling setState
        setState(() {
          _user = UserModel.fromJson(userJson);
        });
      }
    } else {
      print("No user data found in SharedPreferences.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoading
          ? Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryColor, whiteColor],
                ),
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    HomeTopBarWidget(),
                    const SizedBox(height: 5),
                    FrontImageWidget(),
                    const SizedBox(height: 20),
                    FoodCategoryWidget(),
                    const SizedBox(height: 20),
                    ShopWidget(_shopsData),
                    const SizedBox(height: 10),
                    HomeProductListWidget(
                      title: "Momo",
                      products: _momo,
                    ),
                    const SizedBox(height: 15),
                    // HomeProductListWidget(
                    //   title: "Chowmein",
                    //   products: _chowmein,
                    // ),
                    // const SizedBox(height: 15),
                    // HomeProductListWidget(
                    //   title: "Fries",
                    //   products: _fries,
                    // ),
                    // const SizedBox(height: 15),
                    // HomeProductListWidget(
                    //   title: "Biryani",
                    //   products: _biryani,
                    // ),
                    // const SizedBox(height: 15),
                    // HomeProductListWidget(
                    //   title: "Burger",
                    //   products: _burger,
                    // ),
                    // const SizedBox(height: 15),
                    // HomeProductListWidget(
                    //   title: "Pizza",
                    //   products: _pizza,
                    // ),
                    // const SizedBox(height: 15),
                    // _shawarma != null && _shawarma.isNotEmpty
                    //     ? HomeProductListWidget(
                    //         title: "Shawarma",
                    //         products: _shawarma,
                    //       )
                    //     : SizedBox.shrink(),
                    // SizedBox(height: 15),
                    // ColoumAllProductsWidgets(
                    //   title: "All Product",
                    //   products: _allProducts,
                    // ),
                    // const SizedBox(height: 15),
                    // isLoadingProduct
                    //     ? Center(
                    //         child: Container(
                    //           child: Center(child: Text("Loading more ...")),
                    //         ),
                    //       )
                    //     : const SizedBox.shrink(),
                    // const SizedBox(height: 15),
                  ],
                ),
              ),
            )
          : Container(
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
            ),
    );
  }

  Widget HomeTopBarWidget() {
    return Container(
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: (_user?.images.isNotEmpty ?? false)
                  ? NetworkImage(
                      _user!.images[0].secureUrl,
                    )
                  : null,
              child: (_user?.images.isNotEmpty ?? false)
                  ? null
                  : Text("${_user?.username?.substring(0, 1).toUpperCase()}",
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                          color: primaryColor)),
            ),
          ),
          Container(
              child: Center(
                  child: Text(
            maxLines: 1,
            "Welcome ${_user?.username}",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: whiteColor),
          ))),
        ],
      ),
    );
  }

  Widget FrontImageWidget() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          height: MediaQuery.of(context).size.height *
              0.4, // Adjust height as needed
          decoration: BoxDecoration(
            border: Border.all(color: whiteColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  child: Image.asset(
                    _imagePaths[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: _imagePaths.length,
          effect: const ExpandingDotsEffect(
            activeDotColor: secondaryColor,
            dotColor: primaryColor,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 8,
          ),
        ),
      ],
    );
  }

  Widget FoodCategoryColum({
    title1,
    title1url,
    title2,
    title2url,
  }) {
    return Column(
      children: [
        Container(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleCategoryProductsWidget(
                            title: title1,
                          )));
            },
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    title1url,
                    fit: BoxFit
                        .cover, // For a better fit of the image inside the container
                  ),
                ),
                Text(title1,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleCategoryProductsWidget(
                            title: title2,
                          )));
            },
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    title2url,
                    fit: BoxFit
                        .cover, // For a better fit of the image inside the container
                  ),
                ),
                Text(title2,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget FoodCategoryWidget() {
    return Container(
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            Container(
                child: const Center(
                    child: Text(
              "- - What's On Your Mind - -",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: blackColor),
            ))),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  FoodCategoryColum(
                    title1: "Momo",
                    title1url: "assets/images/foodCategory/momo.avif",
                    title2: 'Chowmein',
                    title2url: "assets/images/foodCategory/chowmein.jpg",
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  FoodCategoryColum(
                    title1: "Pizza",
                    title1url: "assets/images/foodCategory/pizza.jpeg",
                    title2: 'Burger',
                    title2url: "assets/images/foodCategory/burger.jpeg",
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  FoodCategoryColum(
                    title1: "Fries",
                    title1url: "assets/images/foodCategory/fries.webp",
                    title2: 'Noodles',
                    title2url: "assets/images/foodCategory/noodles.jpg",
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  FoodCategoryColum(
                    title1: "Shawarma",
                    title1url: "assets/images/foodCategory/shawarma.jpg",
                    title2: 'Roll',
                    title2url: "assets/images/foodCategory/roll.jpg",
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  FoodCategoryColum(
                    title1: "Biryani",
                    title1url: "assets/images/foodCategory/biryani.avif",
                    title2: 'Nihari',
                    title2url: "assets/images/foodCategory/nihari.avif",
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  FoodCategoryColum(
                    title1: "Tikka",
                    title1url: "assets/images/foodCategory/tikka.avif",
                    title2: 'Korma',
                    title2url: "assets/images/foodCategory/korma.jpeg",
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  FoodCategoryColum(
                    title1: "Chicken Fry",
                    title1url: "assets/images/foodCategory/friedchicken.jpg",
                    title2: 'Roti',
                    title2url: "assets/images/foodCategory/korma.jpeg",
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ShopWidget(List<shopModels.Shop> shopsData) {
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
                  "All Restaurants",
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 20,
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: whiteColor,
                          textStyle: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard()));
                          },
                          child: Text(
                            "All",
                          ),
                        )),
                  )),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: isLoading
                  ? List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    )
                  : shopsData.map((shop) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (contex) =>
                                          ShopProducts(email: shop.email)));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: shop.image.isNotEmpty
                                  ? Image.network(
                                      shop.image[0].secureUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/placeholder.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/images/placeholder.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
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

  Future<void> getShopsData() async {
    try {
      final response = await http.get(Uri.parse(allShopsApi));
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey('shops')) {
        List<dynamic> shopsData = data['shops'];

        List<shopModels.Shop> shops =
            shopsData.map((json) => shopModels.Shop.fromJson(json)).toList();
        // print("SHop Data : $shops");
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

  Future<void> getMomo() async {
    try {
      final response = await http.get(Uri.parse("$momoApi?limit=3"));
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey('Products')) {
        List<dynamic> productsData = data['Products'];

        List<ProductModel> allProducts =
            productsData.map((json) => ProductModel.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            _momo = allProducts;
          });
        }
      } else {
        throw Exception('Failed to load shops');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> getChowmein() async {
    try {
      final response = await http.get(Uri.parse("$chowmeinApi?limit=3"));
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey('Products')) {
        print("1");
        List<dynamic> productsData = data['Products'];

        List<ProductModel> allProducts =
            productsData.map((json) => ProductModel.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            _chowmein = allProducts;
          });
        }
      } else {
        throw Exception('Failed to load shops');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> getFries() async {
    try {
      final response = await http.get(Uri.parse("$friesApi?limit=3"));
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey('Products')) {
        print("1");
        List<dynamic> productsData = data['Products'];

        List<ProductModel> allProducts =
            productsData.map((json) => ProductModel.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            _fries = allProducts;
          });
        }
      } else {
        throw Exception('Failed to load shops');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> getBiryani() async {
    try {
      final response = await http.get(Uri.parse("$biryaniApi?limit=3"));
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey('Products')) {
        List<dynamic> productsData = data['Products'];

        List<ProductModel> allProducts =
            productsData.map((json) => ProductModel.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            _biryani = allProducts;
          });
        }
      } else {
        throw Exception('Failed to load shops');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> getPizza() async {
    try {
      final response = await http.get(Uri.parse("$pizzaApi?limit=3"));
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey('Products')) {
        List<dynamic> productsData = data['Products'];

        List<ProductModel> allProducts =
            productsData.map((json) => ProductModel.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            _pizza = allProducts;
          });
        }
      } else {
        throw Exception('Failed to load shops');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> getBurger() async {
    try {
      final response = await http.get(Uri.parse("$burgerApi?limit=3"));
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey('Products')) {
        List<dynamic> productsData = data['Products'];

        List<ProductModel> allProducts =
            productsData.map((json) => ProductModel.fromJson(json)).toList();
        print(allProducts);
        if (mounted) {
          setState(() {
            _burger = allProducts;
          });
        }
      } else {
        throw Exception('Failed to load shops');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> getshawarma() async {
    try {
      final response = await http.get(Uri.parse("$shawarmaApi?limit=3"));
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey('Products')) {
        List<dynamic> productsData = data['Products'];

        List<ProductModel> allProducts =
            productsData.map((json) => ProductModel.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            _shawarma = allProducts;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load shops');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> getAllProducts() async {
    setState(() {
      isLoadingProduct = true;
    });
    try {
      final response = await http.get(
          Uri.parse("$allProductsApi?limit=5&skip=${_allProducts.length}"));
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey('Products')) {
        List<dynamic> productsData = data['Products'];

        List<ProductModel> allProducts =
            productsData.map((json) => ProductModel.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            _allProducts.addAll(allProducts);
            isLoadingProduct = false;
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
