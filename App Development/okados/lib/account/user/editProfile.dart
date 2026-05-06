import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:okados/account/forgetpassword/forgetpassword.dart';
import 'package:okados/config/config.dart';
import 'package:okados/model/user.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  UserModel? _user;
  bool isLoadingUpdate = false;
  bool oldPasswordNoMatch = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('User');

    if (userString != null) {
      final userJson = jsonDecode(userString);
      if (mounted) {
        setState(() {
          _user = UserModel.fromJson(userJson);

          // Initialize text controllers with user data
          _usernameController.text = _user?.username ?? '';
          _emailController.text = _user?.email ?? '';
          _phoneNumberController.text = _user?.phoneNumber.toString() ?? '';
          _addressController.text = _user?.address ?? '';
          _landmarkController.text = _user?.landmark ?? '';
          _pincodeController.text = _user?.pincode ?? '';
          _cityController.text = _user?.city ?? '';
          _stateController.text = _user?.state ?? '';
        });
      }
    } else {
      print("No user data found in SharedPreferences.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBackgroundColor, whiteColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              _ProfileContainer(),
              _AddressContainer(),
              _PasswordContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ProfileContainer() {
    return Container(
      width: double.infinity,
      height: 120,
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
            colors: [primaryBackgroundColor, secondaryBackgroundColor]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 40, // Larger radius for the main avatar
                  backgroundImage: (_user?.images.isNotEmpty ?? false)
                      ? NetworkImage(
                          _user?.images[0].secureUrl.toString() ?? '')
                      : null,
                  child: (_user?.images.isNotEmpty ?? false)
                      ? null // No child if there's an image
                      : const Icon(
                          Icons.person,
                          size: 40,
                          color: secondaryColor,
                        ),
                ),
                // Positioned(
                //   bottom: 0,5
                //   right: 0,
                //   child: InkWell(
                //     onTap: () {
                //       // Handle edit action here
                //       print("Edit button tapped");
                //     },
                //     child: Container(
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color:
                //             primaryColor, // Background color for the edit icon
                //       ),
                //       padding: EdgeInsets.all(5),
                //       child: Icon(
                //         Icons.edit,
                //         size: 18,
                //         color: Colors.white, // Icon color
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_user?.username.toString()}",
                      maxLines:
                          1, // Ensures the text is restricted to a single line
                      overflow: TextOverflow
                          .ellipsis, // Adds "..." if the text overflows
                      style: const TextStyle(
                          color: whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: whiteColor),
                      onPressed: () => _showEditUserSheet(),
                    ),
                  ],
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

  Widget _AddressContainer() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
            colors: [primaryBackgroundColor, secondaryBackgroundColor]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Address : ",
                  maxLines: 1,
                  style: TextStyle(
                      color: blackColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: whiteColor),
                  onPressed: () => _showEditAddressSheet(),
                ),
              ],
            ),
            Text(
              "Address : ${_user?.address.toString()}",
              maxLines: 1,
              style: const TextStyle(color: whiteColor, fontSize: 15),
            ),
            Text(
              "Landmark : ${_user?.landmark.toString()}",
              maxLines: 1,
              style: const TextStyle(color: whiteColor, fontSize: 15),
            ),
            Text(
              "Pincode : ${_user?.pincode.toString()}",
              maxLines: 1,
              style: const TextStyle(color: whiteColor, fontSize: 15),
            ),
            Text(
              "City :  ${_user?.city.toString()}",
              maxLines: 1,
              style: const TextStyle(color: whiteColor, fontSize: 15),
            ),
            Text(
              "State :  ${_user?.state.toString()}",
              maxLines: 1,
              style: const TextStyle(color: whiteColor, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _PasswordContainer() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
            colors: [primaryBackgroundColor, secondaryBackgroundColor]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Update Password",
              maxLines: 1,
              style: TextStyle(
                  color: blackColor, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: whiteColor),
              onPressed: () => _showEditPasswordSheet(),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUserSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              enabled: false,
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email Can't Change"),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: "PhoneNumber"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryBackgroundColor,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onPressed: () {
                updateProfile();
                Navigator.pop(context);
              },
              child: Text(
                "Update",
                style: TextStyle(color: whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAddressSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: _landmarkController,
              decoration: InputDecoration(labelText: "Landmark"),
            ),
            TextField(
              controller: _pincodeController,
              decoration: InputDecoration(labelText: "Pincode"),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: "City"),
            ),
            TextField(
              controller: _stateController,
              decoration: InputDecoration(labelText: "State"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryBackgroundColor,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onPressed: () {
                // Handle saving of the updated address here
                updateAddress();
                Navigator.pop(context);
              },
              child: Text(
                "Update Address",
                style: TextStyle(color: whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPasswordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(labelText: "Old Password"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
            ),
            TextField(
              controller: _rePasswordController,
              decoration: InputDecoration(labelText: "Re Enter Password"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryBackgroundColor,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onPressed: () {
                // Handle saving of the updated address here
                updatePassword();
                Navigator.pop(context);
              },
              child: Text(
                "Update Password",
                style: TextStyle(color: whiteColor),
              ),
            ),
            oldPasswordNoMatch
                ? TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contex) => ForgetPassword()));
                    },
                    child: const Text(
                      "ForgotPassword",
                      style: TextStyle(
                          fontSize: 18,
                          color: primaryColor,
                          decoration: TextDecoration.underline),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    if (_emailController.text.isEmpty) {
      showSnackBar(context, "Please Enter Email");
      return;
    }

    if (_usernameController.text.isEmpty) {
      showSnackBar(context, "Please Enter Username");
      return;
    }

    if (_usernameController.text.length >= 15) {
      showSnackBar(context, "Username to long");
      return;
    }

    if (_phoneNumberController.text.isEmpty) {
      showSnackBar(context, "Please Enter PhoneNumber");
      return;
    }

    if (_phoneNumberController.text.length != 10) {
      showSnackBar(context, "Wrong Phone Number");
      return;
    }

    final reqBody = {
      "email": _emailController.text,
      "username": _usernameController.text,
      "phoneNumber": _phoneNumberController.text,
    };

    setState(() {
      isLoadingUpdate = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            userUpdateNamePhoneApi), // Ensure 'login' is defined correctly
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 400) {
        showSnackBar(context, "Please enter All required fields");
        setState(() {
          isLoadingUpdate = false;
        });
      }

      if (response.statusCode == 404) {
        showSnackBar(context, "User Not Found");
        setState(() {
          isLoadingUpdate = false;
        });
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("data : $data");
        final prefs = await SharedPreferences.getInstance();
        final userJson = data['User'];
        UserModel user = UserModel.fromJson(userJson);
        await prefs.setString('User', jsonEncode(user.toJson()));
        showSnackBar(context, "Update Successfully");
        setState(() {
          isLoadingUpdate = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Editprofile()));
      }
    } catch (e) {
      showSnackBar(context, "An error occurred: $e");
      setState(() {
        isLoadingUpdate = false;
      });
    } finally {
      setState(() {
        isLoadingUpdate = false;
      });
    }
  }

  Future<void> updateAddress() async {
    if (_addressController.text.isEmpty) {
      showSnackBar(context, "Please Enter Address");
      return;
    }

    if (_landmarkController.text.isEmpty) {
      showSnackBar(context, "Please Enter Landmark");
      return;
    }

    if (_pincodeController.text.isEmpty) {
      showSnackBar(context, "Please Enter Pincode");
      return;
    }
    if (_pincodeController.text.length > 6 ||
        _pincodeController.text.length < 6) {
      showSnackBar(context, "Wrong Pincode");
      return;
    }

    if (_cityController.text.isEmpty) {
      showSnackBar(context, "Please Enter City");
      return;
    }

    if (_stateController.text.isEmpty) {
      showSnackBar(context, "Please Enter State");
      return;
    }

    final reqBody = {
      "email": _emailController.text,
      "address": _addressController.text,
      "landmark": _landmarkController.text,
      "pincode": _pincodeController.text,
      "city": _cityController.text,
      "state": _stateController.text,
    };

    setState(() {
      isLoadingUpdate = true;
    });

    try {
      final response = await http.post(
        Uri.parse(userUpdateAddressApi), // Ensure 'login' is defined correctly
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 400) {
        showSnackBar(context, "Please enter All required fields");
        setState(() {
          isLoadingUpdate = false;
        });
      }

      if (response.statusCode == 404) {
        showSnackBar(context, "User Not Found");
        setState(() {
          isLoadingUpdate = false;
        });
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("data : $data");
        final prefs = await SharedPreferences.getInstance();
        final userJson = data['User'];
        UserModel user = UserModel.fromJson(userJson);
        await prefs.setString('User', jsonEncode(user.toJson()));
        showSnackBar(context, "Address Successfully");
        setState(() {
          isLoadingUpdate = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Editprofile()));
      }
    } catch (e) {
      showSnackBar(context, "An error occurred: $e");
      setState(() {
        isLoadingUpdate = false;
      });
    } finally {
      setState(() {
        isLoadingUpdate = false;
      });
    }
  }

  Future<void> updatePassword() async {
    if (_oldPasswordController.text.isEmpty) {
      showSnackBar(context, "Please Enter Old Password");
      return;
    }

    if (_passwordController.text.isEmpty) {
      showSnackBar(context, "Please Enter Password");
      return;
    }

    if (_rePasswordController.text.isEmpty) {
      showSnackBar(context, "Please Re-Enter Password");
      return;
    }

    if (_passwordController.text != _rePasswordController.text) {
      showSnackBar(context, "Password Not Match");
      return;
    }

    final reqBody = {
      "email": _emailController.text,
      "password": _oldPasswordController.text,
      "newPassword": _passwordController.text,
    };

    setState(() {
      isLoadingUpdate = true;
    });

    try {
      final response = await http.post(
        Uri.parse(userUpdatePasswordApi), // Ensure 'login' is defined correctly
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 400) {
        showSnackBar(context, "Please enter All required fields");
        setState(() {
          isLoadingUpdate = false;
        });
      }

      if (response.statusCode == 404) {
        showSnackBar(context, "User Not Found");
        setState(() {
          isLoadingUpdate = false;
        });
      }

      if (response.statusCode == 401) {
        showSnackBar(context, "Old Password Wrong");
        setState(() {
          isLoadingUpdate = false;
          oldPasswordNoMatch = true;
        });
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        showSnackBar(context, "Password Updated");
        setState(() {
          isLoadingUpdate = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Editprofile()));
      }
    } catch (e) {
      showSnackBar(context, "An error occurred: $e");
      setState(() {
        isLoadingUpdate = false;
      });
    } finally {
      setState(() {
        isLoadingUpdate = false;
      });
    }
  }
}
