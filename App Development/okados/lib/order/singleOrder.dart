import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:okados/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:okados/model/order.dart';
import 'package:okados/model/user.dart';

class Singleorder extends StatefulWidget {
  final String? orderId;
  const Singleorder({Key? key, required this.orderId}) : super(key: key);

  @override
  State<Singleorder> createState() => _SingleorderState();
}

class _SingleorderState extends State<Singleorder> {
  bool _isLoading = false;
  UserModel? _user;
  OrderModel? _order;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Address",
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
              orderId(),
              const SizedBox(
                height: 4,
              ),
              products(),
              const SizedBox(
                height: 4,
              ),
              deliveyStatus(),
              const SizedBox(
                height: 4,
              ),
              shippingDetails(),
              const SizedBox(
                height: 4,
              ),
              bill(),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderId() {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            "Order ID - ",
            style: TextStyle(color: blackColor),
          ),
          Text(
            "${widget.orderId}",
            style: const TextStyle(color: blackColor),
          ),
        ],
      ),
    );
  }

  Widget products() {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: whiteColor,
                  ),
                )
              : _order == null || _order!.products == null
                  ? const Center(
                      child: Text(
                        "No products found.",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : Column(
                      children: _order!.products!.map((product) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title ?? "No Title",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Quantity : ",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          product.quantity.toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Price : ",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          (product.quantity! * product.price!)
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.width * 0.3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    product.imagesInfo![0].secureUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
        ],
      ),
    );
  }

  Widget deliveyStatus() {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18), color: greenColor),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: whiteColor,
                    size: 15,
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 3,
                color: _order?.deliverystatus?.pack.toString() == "succeeded"
                    ? greenColor
                    : _order?.deliverystatus?.pack.toString() == "cancelled"
                        ? redColor
                        : grayColor,
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: _order?.deliverystatus?.pack.toString() ==
                            "succeeded"
                        ? greenColor
                        : _order?.deliverystatus?.pack.toString() == "succeeded"
                            ? redColor
                            : grayColor),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: whiteColor,
                    size: 15,
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 3,
                color: _order?.deliverystatus?.pack.toString() == "succeeded"
                    ? greenColor
                    : _order?.deliverystatus?.pack.toString() == "cancelled"
                        ? redColor
                        : grayColor,
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: _order?.deliverystatus?.pack.toString() ==
                            "succeeded"
                        ? greenColor
                        : _order?.deliverystatus?.pack.toString() == "succeeded"
                            ? redColor
                            : grayColor),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: whiteColor,
                    size: 15,
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 3,
                color: _order?.deliverystatus?.pack.toString() == "succeeded"
                    ? greenColor
                    : _order?.deliverystatus?.pack.toString() == "cancelled"
                        ? redColor
                        : grayColor,
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: _order?.deliverystatus?.pack.toString() ==
                            "succeeded"
                        ? greenColor
                        : _order?.deliverystatus?.pack.toString() == "succeeded"
                            ? redColor
                            : grayColor),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: whiteColor,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  child: const Text("Order Confirmed"),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 20,
                  child: Text("Pack"),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 20,
                  child: Text("Shipped"),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 20,
                  child: Text("Delivered"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget shippingDetails() {
    return Container(
      color: whiteColor,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Shipping Details :",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 3),
            child: Container(
              height: 2,
              width: double.infinity,
              color: grayColor,
            ),
          ),
          Row(
            children: [
              const Text(
                "Name : ",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
              Text(
                _order?.username.toString() ?? "",
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Text(
            _order?.address.toString() ?? "Address",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          ),
          Text(
            _order?.landmark.toString() ?? "Landmark",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          ),
          Text(
            _order?.pincode.toString() ?? "Pincode",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          ),
          Row(
            children: [
              const Text(
                "Phone number : ",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
              ),
              Text(
                _order?.phoneNumber.toString() ?? "Phone number",
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bill() {
    return Container(
      color: whiteColor,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          const Text(
            "Price Details :",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 3),
            child: Container(
              height: 2,
              width: double.infinity,
              color: grayColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Price  ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Text(
                _order?.totalPrice.toString() ?? "",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Delivery Charge  ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Text(
                _order?.deliveryCharge.toString() ?? "",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Text  ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Text(
                _order?.textCharge.toString() ?? "",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 3),
            child: Container(
              height: 2,
              width: double.infinity,
              color: grayColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount  ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                ((_order?.totalPrice?.toInt() ?? 0) +
                        (_order?.deliveryCharge?.toInt() ?? 0) +
                        (_order?.textCharge?.toInt() ?? 0))
                    .toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getOrder() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.orderId == null) {
      return;
    }

    try {
      final response =
          await http.get(Uri.parse('$byOrderIdApi?orderId=${widget.orderId}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final orderjson = data["order"];
        OrderModel order = OrderModel.fromJson(orderjson);
        setState(() {
          _order = order;
          print(_order);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(
        "Error",
      );
    }
  }
}
