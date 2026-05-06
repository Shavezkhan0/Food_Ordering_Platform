import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:okados/account/user/editProfile.dart';
import 'package:okados/cart/cart_provider.dart';
import 'package:okados/config/config.dart';
import 'package:okados/dataBase/db_helper.dart';
import 'package:okados/model/cart.dart';
import 'package:okados/model/user.dart';
import 'package:okados/navbar/navbar.dart';
import 'package:okados/order/myOrders.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/main.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  DBHelper dbHelper = DBHelper();
  List<Cart> _cart = [];
  UserModel? _user;

  String? orderId;
  final deliveryCharge = 0;
  final textCharge = 0;

  void initState() {
    super.initState();
    orderId = generateOrderId(); // Directly update the variable
    print(orderId); // This should not cause freezing
  }

  String generateOrderId() {
    var random = Random();
    String newOrderId = DateTime.now().millisecondsSinceEpoch.toString();
    return newOrderId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment",
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
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
              TrackPath(),
              ProductDetails(),
              Bill(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () => placeOrder(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    "Place Order",
                    style: TextStyle(fontSize: 16, color: whiteColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget TrackPath() {
    return Container(
      decoration: const BoxDecoration(
          // color: primaryBackgroundColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: greenColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                    child: Text(
                  "1",
                  style: TextStyle(fontSize: 10, color: whiteColor),
                )),
              ),
              const Text("Cart",
                  style: TextStyle(fontSize: 15, color: whiteColor)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width * 0.25,
              color: greenColor,
            ),
          ),
          Column(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: greenColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                    child: Text(
                  "2",
                  style: TextStyle(fontSize: 10, color: whiteColor),
                )),
              ),
              const Text("Address",
                  style: TextStyle(fontSize: 15, color: whiteColor)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width * 0.25,
              color: greenColor,
            ),
          ),
          Column(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: blackColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                    child: Text(
                  "3",
                  style: TextStyle(fontSize: 10, color: whiteColor),
                )),
              ),
              const Text("Payment",
                  style: TextStyle(fontSize: 15, color: whiteColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget ProductDetails() {
    final cart = Provider.of<CartProvider>(context);
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Food Details: ",
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.w600)),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Food",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              Text("Quantity",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              Text("Price",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
          FutureBuilder<List<Cart>>(
            future: cart.getCartData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Your cart is empty."),
                );
              } else {
                final cartItems = snapshot.data!.reversed.toList();
                return ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(item!.title!.toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300)),
                                    Text(item!.quantity!.toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300)),
                                    Text(item!.price!.toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              }
            },
          )
        ],
      ),
    );
  }

  Widget Bill() {
    final cart = Provider.of<CartProvider>(context);
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Bill Details: ",
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: grayColor,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal: ",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400)),
              Row(
                children: [
                  const Icon(Icons.currency_rupee, size: 18, color: greenColor),
                  Text(cart.getTotalPrice().toString(),
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: greenColor)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tax: ",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400)),
              Row(
                children: [
                  const Icon(Icons.currency_rupee, size: 18, color: greenColor),
                  Text(textCharge.toString(),
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: greenColor)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Delivery Charge: ",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400)),
              Row(
                children: [
                  const Icon(Icons.currency_rupee, size: 18, color: greenColor),
                  Text(deliveryCharge.toString(),
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: greenColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: grayColor,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Price: ",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400)),
              Row(
                children: [
                  const Icon(Icons.currency_rupee, size: 18, color: greenColor),
                  Text(
                      (cart.getTotalPrice() + textCharge + deliveryCharge)
                          .toString(),
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: greenColor)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  placeOrder(BuildContext context) async {
    // Define deliveryInfo outside the if block to avoid scope issues
    Map<String, dynamic> userInfo = {};
    Map<String, dynamic> geoLocation = {};

    // Fetch user data from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString("User");
    String? latLongJson = prefs.getString("LatLong");
    if (latLongJson != null) {
      Map<String, double> latLong =
          Map<String, double>.from(jsonDecode(latLongJson));
      double _latitude = latLong['latitude']!.toDouble();
      double _longitude = latLong['longitude']!.toDouble();
      geoLocation = {
        "latitude": _latitude,
        "longitude": _longitude,
      };
    } else {
      print("No LatLong data found");
    }

    if (user != null) {
      final userJson = jsonDecode(user);
      _user = UserModel.fromJson(userJson);
      userInfo = {
        "email": _user?.email,
        "username": _user?.username,
        "phoneNumber": _user?.phoneNumber,
        "address": _user?.address,
        "landmark": _user?.landmark,
        "pincode": _user?.pincode,
        "state": _user?.state,
        "city": _user?.city,
      };
    }

    // Get the cart data and calculate the subtotal
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    double subTotal = cartProvider.getTotalPrice();

    final cartItems = await cartProvider.getCartData();

    // Convert cart items to a map
    final List<Map<String, dynamic>> _cart = cartItems.map((item) {
      return item.toMap();
    }).toList();

    // Headers for the API request
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Body for the API request
    final Map<String, dynamic> body = {
      "orderId": orderId,
      "subTotal": subTotal,
      "deliveryCharge": deliveryCharge,
      "textCharge": textCharge,
      "cart": _cart,
      "userInfo": userInfo,
      "geoLocation": geoLocation,
    };

    try {
      final response = await http.put(
        Uri.parse(placeOrderApi),
        headers: headers,
        body: jsonEncode(body),
      );

      // Check the response status
      if (response.statusCode == 200) {
        showSnackBar(context, "Order Place Successfully");
        cartProvider.clearCart();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Navbar()), // Replace HomePage with your actual home page widget
          (route) => false, // Remove all previous routes
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyOrders()));
      } else {
        print("Error: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
