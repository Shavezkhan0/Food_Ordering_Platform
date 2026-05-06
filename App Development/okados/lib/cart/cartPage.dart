import 'package:flutter/material.dart';
import 'package:okados/cart/cart_provider.dart';
import 'package:okados/config/config.dart';
import 'package:okados/dataBase/db_helper.dart';
import 'package:okados/model/cart.dart';
import 'package:okados/order/orderAddress.dart';
import 'package:okados/products/ProductsWidget.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DBHelper dbHelper = DBHelper();
  late List<PageController> _pageControllers;

  final deliveryCharge = 0;
  final textCharge = 0;

  @override
  void initState() {
    super.initState();
    _pageControllers = [];
  }

  @override
  void dispose() {
    for (var controller in _pageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cart",
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
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  CartList(),
                  const SizedBox(
                    height: 10,
                  ),
                  Bill(),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TrackPath(),
            ),
          ],
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderAddress()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor:
                        Colors.transparent, // Needed for gradient to show
                    shadowColor:
                        Colors.transparent, // // Ensure this is defined
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Address Next",
                        style: TextStyle(
                            fontSize: 16,
                            color: whiteColor), // Ensure whiteColor is defined
                      ),
                    ],
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
          color: primaryBackgroundColor,
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
                  color: blackColor,
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
              color: whiteColor,
            ),
          ),
          Column(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                    child: Text(
                  "2",
                  style: TextStyle(fontSize: 10),
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
              color: whiteColor,
            ),
          ),
          Column(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                    child: Text(
                  "3",
                  style: TextStyle(fontSize: 10),
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

  Widget CartList() {
    final cart = Provider.of<CartProvider>(context);
    return FutureBuilder<List<Cart>>(
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
            shrinkWrap: true, // Ensures the list is only as tall as its content
            physics:
                const NeverScrollableScrollPhysics(), // Prevents scrolling inside the ListView
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              if (index >= _pageControllers.length) {
                _pageControllers.add(PageController());
              }
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductWidget(id: item!.sId)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 300,
                          child: PageView.builder(
                            controller: _pageControllers[index],
                            itemCount: item.imagesInfo?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Image.network(
                                item.imagesInfo![index].secureUrl.toString(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        SmoothPageIndicator(
                          controller: _pageControllers[index],
                          count: item.imagesInfo?.length ?? 0,
                          effect: const ExpandingDotsEffect(
                            activeDotColor: secondaryColor,
                            dotColor: primaryBackgroundColor,
                            dotHeight: 8,
                            dotWidth: 8,
                            spacing: 8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 1,
                          color: grayColor,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item!.title!.toString() ?? "Loading...",
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.currency_rupee,
                                        size: 18,
                                        color: greenColor,
                                      ),
                                      Text(
                                        item!.price.toString() ?? "No price",
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: greenColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.currency_rupee_sharp,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        (item!.price! * 1.1).toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Description: ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  Expanded(
                                    child: Text(
                                      item!.description.toString() ??
                                          "No Description",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Restaurent : ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  Text(item!.shopname.toString() ?? "..."),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("FoodCategory : ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  Text(item!.foodCategory.toString() ?? "..."),
                                  item!.foodCategory.toString() == "nonVeg"
                                      ? const Icon(
                                          Icons.square,
                                          color: Colors.red,
                                        )
                                      : const Icon(
                                          Icons.eco,
                                          color: Colors.green,
                                        ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      item.quantity == 1
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  cart.deleteItem(item.sId!);
                                                  cart.removeCounter();
                                                  cart.removeFromTotalPrice(
                                                      item.price!.toDouble());
                                                });
                                              },
                                              icon: const Icon(Icons.delete,
                                                  color: redColor),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                if ((item.quantity ?? 0) > 1) {
                                                  setState(() {
                                                    cart.decresrQuantity(
                                                        item.sId!);
                                                    cart.removeFromTotalPrice(
                                                        item!.price!
                                                            .toDouble());
                                                  });
                                                } else {
                                                  setState(() {
                                                    dbHelper.removeFromCart(
                                                        item.sId);
                                                    cart.decresrQuantity(
                                                        item.sId!);
                                                    cart.removeFromTotalPrice(
                                                        item!.price!
                                                            .toDouble());
                                                  });
                                                }
                                              },
                                              icon: const Icon(Icons.remove),
                                            ),
                                      const SizedBox(width: 5),
                                      Text(item.quantity.toString()),
                                      const SizedBox(width: 5),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            setState(() {
                                              cart.increseQuantity(item.sId!);
                                              cart.addTotalPrice(
                                                  item!.price!.toDouble());
                                            });
                                          });
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        cart.deleteItem(item.sId!);
                                        cart.removeCounter();
                                        cart.removeFromTotalPrice(
                                            item.price!.toDouble() *
                                                item.quantity!.toDouble());
                                      });
                                    },
                                    child: const Row(
                                      children: [
                                        Text("Remove",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: redColor)),
                                        SizedBox(width: 10),
                                        Icon(Icons.delete, color: redColor),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Total Price",
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: blackColor,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.currency_rupee,
                                        size: 18,
                                        color: greenColor,
                                      ),
                                      Text(
                                        (item!.price!.toInt() *
                                                    item!.quantity!.toInt())
                                                .toString() ??
                                            "No price",
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: greenColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
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
}
