import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:okados/account/forgetpassword/resetpassword.dart';
import 'package:okados/account/user/loginUser.dart';
import 'package:okados/config/config.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  bool isLoadingOtpSend = false;
  bool isLoadingOtpSended = false;
  int? otp;
  Random random = Random();

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
                      "Forget Password",
                      style: TextStyle(
                          fontSize: 30,
                          color: whiteColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: Column(
                      children: [
                        _buildTextField(emailController, "Email", Icons.email),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildOtpSendButton(),
                        const SizedBox(
                          height: 20,
                        ),
                        if (isLoadingOtpSended)
                          _buildTextField(otpController, "Otp", Icons.verified,
                              isNumeric: true)
                        else
                          const SizedBox.shrink(),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildOtpVerifyButton(),
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

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isNumeric = false,
  }) {
    return Container(
      child: TextField(
        controller: controller,
        keyboardType:
            isNumeric ? TextInputType.number : TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: secondaryColor,
          ),
          hintText: hint,
          filled: true,
          fillColor: grayColor,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: blackColor, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: whiteColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
    );
  }

  Widget _buildOtpSendButton() {
    return Container(
      child: !isLoadingOtpSend
          ? ElevatedButton(
              onPressed: () => sendOtp(),
              style: ElevatedButton.styleFrom(
                elevation: 20,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              child: Text(isLoadingOtpSended ? "Resend OTP" : "Send OTP",
                  style: const TextStyle(fontSize: 18)),
            )
          : const CircularProgressIndicator(
              color: whiteColor,
            ),
    );
  }

  Widget _buildOtpVerifyButton() {
    return Container(
      child: isLoadingOtpSended
          ? ElevatedButton(
              onPressed: () => otpVerifyFn(),
              style: ElevatedButton.styleFrom(
                elevation: 20,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              child: const Text("Verify", style: TextStyle(fontSize: 18)),
            )
          : null,
    );
  }

  sendOtp() async {
    if (emailController.text.isEmpty) {
      showSnackBar(context, "Please Enter email");
      return;
    }
    bool isvalidEmail = isValidEmail(emailController.text);
    if (!isvalidEmail) {
      showSnackBar(context, "Please Enter Valid Email");
      return;
    }

    setState(() {
      isLoadingOtpSend = true;
    });

    final response = await http.post(Uri.parse(existApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": emailController.text}));

    if (response.statusCode == 200) {
      showSnackBar(context, "User not Exist");
      setState(() {
        isLoadingOtpSend = false;
      });
      return;
    }

    otp = 100000 + random.nextInt(900000);
    try {
      final response = await http.post(
        Uri.parse(otpVerifyApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": emailController.text, "otp": otp}),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoadingOtpSend = false;
          isLoadingOtpSended = true;
          otpController.clear();
        });
      }
    } catch (e) {
      print(e);
      showSnackBar(context, "Wrong Email");
      setState(() {
        isLoadingOtpSend = false;
      });
    }
  }

  otpVerifyFn() async {
    setState(() {
      isLoadingOtpSended = true;
    });
    if (otpController.text.isEmpty) {
      showSnackBar(context, 'Enter Otp');
      return;
    }

    print(int.tryParse(otpController.text) != otp);
    print("${int.tryParse(otpController.text)} != $otp");

    if (int.tryParse(otpController.text) != otp) {
      showSnackBar(context, 'Wrong Otp');
      return;
    }

    setState(() {
      isLoadingOtpSended = false;
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReSetPassword(email: emailController.text)));
  }
}

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}
