import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:okados/account/user/editProfile.dart';
import 'package:okados/config/config.dart';
import 'package:okados/model/user.dart';
import 'package:okados/order/myOrders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('User');

    if (userString != null) {
      // Decode the JSON string back into a UserModel
      final userJson = jsonDecode(userString);
      if (mounted) {
        // Ensure the widget is still mounted before calling setState
        setState(() {
          _user = UserModel.fromJson(userJson);
          // print(_user?.images[0].secureUrl.toString());
        });
      }
    } else {
      print("No user data found in SharedPreferences.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor, whiteColor])),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            _ProfileContainer(),
            const SizedBox(
              height: 40,
            ),
            RowProContaiber(),
            const SizedBox(
              height: 20,
            ),
            RowOrderContaiber(),
          ],
        ),
      ),
    );
  }

  Widget _ProfileContainer() {
    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: whiteColor,
        gradient: const LinearGradient(
            colors: [primaryBackgroundColor, secondaryBackgroundColor]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30, // Increase the radius to make the avatar larger
              child: (_user?.images.isNotEmpty ?? false)
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(
                        _user?.images[0].secureUrl.toString() ??
                            '', // Provide a fallback URL or empty string
                      ),
                      radius: 40.0, // Optional: Adjust the size as needed
                    )
                  : const Icon(
                      Icons.person,
                      size: 30,
                      color: secondaryColor,
                    ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${_user?.username.toString()}",
                  maxLines: 1,
                  style: const TextStyle(color: whiteColor, fontSize: 20),
                ),
                Text(
                  "${_user?.email.toString()}",
                  maxLines: 1,
                  style: const TextStyle(color: whiteColor, fontSize: 15),
                ),
                Text(
                  "${_user?.phoneNumber.toString()}",
                  maxLines: 1,
                  style: const TextStyle(color: whiteColor, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget RowProContaiber() {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient:
            const LinearGradient(colors: [grayColor, primaryBackgroundColor]),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Editprofile()));
        },
        child: const Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: whiteColor,
                    radius: 27,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Your Profile",
                      style: TextStyle(fontSize: 15, color: blackColor))
                ],
              ),
              Icon(
                Icons.keyboard_arrow_right,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget RowOrderContaiber() {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient:
            const LinearGradient(colors: [grayColor, primaryBackgroundColor]),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyOrders()));
        },
        child: const Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: whiteColor,
                    radius: 27,
                    child: Icon(Icons.shopping_bag),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("My Order",
                      style: TextStyle(fontSize: 15, color: blackColor))
                ],
              ),
              Icon(
                Icons.keyboard_arrow_right,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
