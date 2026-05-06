import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:okados/config/config.dart';
import 'package:okados/model/cart.dart';
import 'package:okados/model/order.dart';
import 'package:okados/model/user.dart';
import 'package:okados/order/singleOrder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  UserModel? _user;
  List<OrderModel> _order = [];
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getallOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
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
      body: _isLoading
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
                    _order.isEmpty ? noMoreOrder() : orderList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget orderList() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: ListView.builder(
              itemCount: _order.length,
              itemBuilder: (context, index) {
                final order = _order[index];
                final products = order.products;
                final imageUrl = order.products![0].imagesInfo;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, left: 5, right: 5),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(color: primaryBackgroundColor)),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Singleorder(orderId: order.orderId))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.3,
                          child: Image.network(imageUrl![0].secureUrl!),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: products!.map((product) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        product.title ?? "No Title",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ); // Display product title
                              }).toList(),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: primaryColor,
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget noMoreOrder() {
    return Container(
      width: MediaQuery.of(context).size.height * 0.3,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
      decoration: BoxDecoration(
        border: Border.all(color: primaryBackgroundColor),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
            spreadRadius: 2, // How much the shadow spreads
            blurRadius: 5, // How soft the shadow looks
            offset: Offset(0, 3), // The x and y offset of the shadow
          ),
        ],
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No Order",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            ],
          )
        ],
      ),
    );
  }

  getallOrders() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString("User");
    if (user != null) {
      final userJson = jsonDecode(user);
      _user = UserModel.fromJson(userJson);
    }

    try {
      final response =
          await http.get(Uri.parse('$userOrdersApi/?email=${_user!.email}'));

      if (response.statusCode == 500) {
        print("Server error. Please try again later.");
        return;
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> orders = data["orders"];
        print("1");
        print(data);
        print("2");
        print(orders);
        print("3");
        List<OrderModel> ordersList =
            orders.map((order) => OrderModel.fromJson(order)).toList();
        print("4");
        setState(() {
          _order = ordersList;
          _isLoading = false;
        });
      }
      setState(() {
        _isLoading = false;
      });
      print("5");
      print(_order);
      print("Order contents: $_order");
      print("Order isEmpty: ${_order.isEmpty}");
      print("_isLoading ${_isLoading}");
      print("6");
    } catch (e) {
      print(e);
    }
  }
}
