import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:okados/config/config.dart';
import 'package:okados/model/cart.dart';
import 'package:okados/model/shopModel.dart' as shopModels;
import 'package:okados/shop/shopProducts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<shopModels.Shop> _shopsData = [];

  @override
  void initState() {
    getShopsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Restaurent",
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
        child: ListView.builder(
          itemCount: _shopsData.length,
          itemBuilder: (context, index) {
            final shop = _shopsData[index];
            return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) =>
                                ShopProducts(email: shop.email)));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top:
                              Radius.circular(10), // Rounded corners at the top
                        ),
                        child: Container(
                          color: whiteColor,
                          height: 210,
                          width: double.infinity,
                          child: Image.network(
                            shop.image[0].secureUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shop.username,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Landmark : ",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        shop.landmark,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  shop.shop == 'on'
                                      ? Text(
                                          shop.shop,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: greenColor),
                                        )
                                      : Text(
                                          shop.shop,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: redColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                //  ListTile(
                //   leading: Image.network(
                //     shop.image[0].secureUrl,
                //   ),
                //   title: Text(shop.username),
                //   subtitle: Text(shop.address),
                //   trailing: const Icon(Icons.arrow_forward_ios),
                // ),
                );
          },
        ),
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
}
