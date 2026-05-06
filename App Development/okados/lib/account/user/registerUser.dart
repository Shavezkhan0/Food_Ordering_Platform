import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:okados/account/forgetpassword/forgetpassword.dart';
import 'package:okados/account/user/loginUser.dart';
import 'package:okados/account/user/otpVerification.dart';
import 'package:okados/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:okados/navbar/navbar.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();

  bool isLoading = false;
  bool showPass = true;
  bool reshowPass = true;

  final random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            secondaryColor,
            primaryColor,
          ])),
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.15,
            ),
            child: SingleChildScrollView(
              // Directly wrap the Column here
              child: Column(
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
                    height: 30,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: Column(
                        children: [
                          _buildTextField(
                              usernameController, "User Name", Icons.person),
                          const SizedBox(height: 20),
                          _buildTextField(
                              emailController, "Email", Icons.email),
                          const SizedBox(height: 20),
                          _buildTextField(phoneNumberController, "Phone Number",
                              Icons.phone,
                              isNumeric: true),
                          const SizedBox(height: 20),
                          _buildTextField(
                              passwordController, "Password", Icons.password,
                              isPassword: true), // Password field
                          const SizedBox(height: 20),
                          _buildTextField(repasswordController,
                              "Re Enter Password", Icons.password,
                              isPassword: true,
                              isRePassword: true), // Re-enter Password field
                          const SizedBox(height: 20),
                          _buildRegisterButton(),
                          const SizedBox(height: 30),
                          _buildFooterButtons(context),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {bool isPassword = false,
      bool isNumeric = false,
      bool isRePassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: grayColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText:
            isPassword ? (isRePassword ? reshowPass : showPass) : false,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: secondaryColor),
          suffixIcon: isPassword
              ? InkWell(
                  onTap: () {
                    setState(() {
                      if (isRePassword) {
                        reshowPass = !reshowPass;
                      } else {
                        showPass = !showPass;
                      }
                    });
                  },
                  child: Icon(
                    (isRePassword ? reshowPass : showPass)
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: secondaryColor,
                  ),
                )
              : null,
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

  Widget _buildRegisterButton() {
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
              child: const Text("Register", style: TextStyle(fontSize: 18)),
            )
          : const CircularProgressIndicator(
              color: whiteColor,
            ),
    );
  }

  Widget _buildFooterButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (contex) => ForgetPassword()));
          },
          child: const Text(
            "ForgotPassword",
            style: TextStyle(
                fontSize: 18,
                color: whiteColor,
                decoration: TextDecoration.underline),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (contex) => LoginUser()));
            },
            child: const Text(
              "Login",
              style: TextStyle(
                  fontSize: 18,
                  color: whiteColor,
                  decoration: TextDecoration.underline),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> registerUser() async {
    if (usernameController.text.isEmpty) {
      showSnackBar(context, "Please Enter Username");
      return;
    }
    if (usernameController.text.length >= 15) {
      showSnackBar(context, "Username to long");
      return;
    }
    if (emailController.text.isEmpty) {
      showSnackBar(context, "Please Enter Email");
      return;
    }
    bool isvalidEmail = isValidEmail(emailController.text);
    if (!isvalidEmail) {
      showSnackBar(context, "Please Enter Valid Email");
      return;
    }
    if (phoneNumberController.text.isEmpty ||
        phoneNumberController.text.length != 10) {
      showSnackBar(context, "Please Enter Phone Number");
      return;
    }
    if (passwordController.text.isEmpty) {
      showSnackBar(context, "Please Enter Password");
      return;
    }
    if (repasswordController.text.isEmpty) {
      showSnackBar(context, "Please Re Enter  Password");
      return;
    }
    if (passwordController.text != repasswordController.text) {
      showSnackBar(context, "Password Not Match");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.post(Uri.parse(existApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": emailController.text}));

    if (response.statusCode == 404) {
      showSnackBar(context, "Unexpected Error");
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (response.statusCode == 409) {
      showSnackBar(context, "User Already Register");
      setState(() {
        isLoading = false;
      });
      return;
    }

    final otp = 100000 + random.nextInt(900000);
    final reqBody = {
      "otp": otp,
      "username": usernameController.text,
      "email": emailController.text,
      "phoneNumber": phoneNumberController.text,
      "password": passwordController.text
    };

//sendTop
    try {
      final response = await http.post(
        Uri.parse(otpVerifyApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": emailController.text, "otp": otp}),
      );

      if (response.statusCode == 404) {
        showSnackBar(context, "Unexpected Error");
        setState(() {
          isLoading = false;
        });
        return;
      }
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpVerification(reqBody: reqBody)));
      }
    } catch (e) {
      print(e);
      showSnackBar(context, "Wrong Email");
      setState(() {
        isLoading = false;
      });
    }
  }
}

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}
