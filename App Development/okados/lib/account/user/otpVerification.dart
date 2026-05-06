import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:okados/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:okados/model/user.dart';
import 'package:okados/navbar/navbar.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerification extends StatefulWidget {
  final Map<String, dynamic> reqBody;

  const OtpVerification({Key? key, required this.reqBody}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  TextEditingController otpController = TextEditingController();

  final random = Random();
  bool isLoading = false;
  bool isLoadingReOtp = false;

  String? username;
  String? email;
  String? phoneNumber;
  String? password;
  int? otp;

  @override
  void initState() {
    super.initState();
    // Accessing information from reqBody
    username = widget.reqBody["username"];
    email = widget.reqBody["email"];
    phoneNumber = widget.reqBody["phoneNumber"];
    password = widget.reqBody["password"];
    otp = widget.reqBody["otp"];
    print(otp);
    print(widget.reqBody);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [secondaryColor, primaryColor]),
        ),
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 30,
                          color: whiteColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: Column(
                      children: [
                        _buildOtpTextField(),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildOtpButton(),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildReOtpButton(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpTextField() {
    return Container(
      child: TextField(
        controller: otpController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.verified),
          hintText: "Otp",
          filled: true,
          fillColor: grayColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: blackColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: whiteColor, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
    );
  }

  Widget _buildOtpButton() {
    return Container(
      child: !isLoading
          ? ElevatedButton(
              onPressed: () => registerUser(),
              style: ElevatedButton.styleFrom(
                elevation: 20,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              child: const Text("Verify", style: TextStyle(fontSize: 18)),
            )
          : const CircularProgressIndicator(
              color: whiteColor,
            ),
    );
  }

  Widget _buildReOtpButton() {
    return Container(
      child: !isLoadingReOtp
          ? ElevatedButton(
              onPressed: () => reSendOtp(),
              style: ElevatedButton.styleFrom(
                elevation: 20,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              child: const Text("Resend Otp", style: TextStyle(fontSize: 18)),
            )
          : const CircularProgressIndicator(
              color: whiteColor,
            ),
    );
  }

  registerUser() async {
    if (otpController.text.isEmpty) {
      showSnackBar(context, 'Enter Otp');
      return;
    }

    if (int.tryParse(otpController.text) != otp) {
      showSnackBar(context, 'Wrong Otp');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final reqBody = {
      "username": username,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password
    };

    try {
      final response = await http.post(
        Uri.parse(registerApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );

      if (response.statusCode == 404) {
        showSnackBar(context, "Unexpected Error");
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (response.statusCode == 400) {
        showSnackBar(context, "Please fill all  Fields");
        setState(() {
          isLoading = false;
        });
        return;
      }
      if (response.statusCode == 409) {
        showSnackBar(context, "User Already Exist");
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        final userJson = data['User'];
        UserModel user = UserModel.fromJson(userJson);
        await prefs.setString('User', jsonEncode(user.toJson()));
        showSnackBar(context, "User Register Successfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Navbar()),
        );
      }
    } catch (e) {
      showSnackBar(context, "An error occurred: $e");
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  reSendOtp() async {
    setState(() {
      isLoadingReOtp = true;
    });

    final otp2 = 100000 + random.nextInt(900000);

    try {
      final response = await http.post(
        Uri.parse(otpVerifyApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "otp": otp2}),
      );

      if (response.statusCode == 404) {
        showSnackBar(context, "Unexpected Error");
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (response.statusCode == 200) {
        showSnackBar(context, "OTP Resend Successfully");
        setState(() {
          isLoadingReOtp = false;
          otp = otp2;
          otpController.clear();
        });
        return;
      }
    } catch (e) {
      print(e);
      showSnackBar(context, "Wrong Email");
      setState(() {
        isLoadingReOtp = false;
      });
    }
  }
}
