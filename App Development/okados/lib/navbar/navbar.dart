import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:badges/badges.dart' as badges; // Import the badges package
import 'package:okados/account/account.dart';
import 'package:okados/cart/cartPage.dart';
import 'package:okados/cart/cart_provider.dart';
import 'package:okados/config/config.dart';
import 'package:okados/dashboard/dashboard.dart';
import 'package:okados/home/home.dart';
import 'package:provider/provider.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _pageIndex = 0;

  // Example cart count
  int cartItemCount = 3;

  final List<Widget> _pages = [
    Home(),
    Dashboard(),
    CartPage(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: _pages[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: primaryColor,
        height: 55,
        animationDuration: const Duration(milliseconds: 350),
        backgroundColor: whiteColor,
        buttonBackgroundColor: secondaryColor,
        items: [
          const Icon(
            Icons.home,
            color: Colors.white,
          ),
          const Icon(
            Icons.dashboard,
            color: Colors.white,
          ),
          // Cart icon with badge
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: -12, end: -12),
            showBadge: cartItemCount > 0,
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  '${value.getCounter().toString()}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                );
              },
            ),
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
          const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ],
        index: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
