import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:okados/account/user/loginUser.dart';
import 'package:okados/config/config.dart';
import 'package:okados/navbar/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null && !JwtDecoder.isExpired(token)) {
        // User is logged in, navigate to home
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Navbar()));
      } else {
        // User is not logged in, navigate to login page
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginUser()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          secondaryColor,
          primaryColor,
        ])),

        // color: primaryColor,
        child: const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Okhla Dastarkhan",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              "Online Service",
              style: TextStyle(
                  fontSize: 25,
                  color: yellowColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        )),
      ),
    );
  }
}
