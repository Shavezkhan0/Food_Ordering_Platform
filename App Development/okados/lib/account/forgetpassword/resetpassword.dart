import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:okados/account/user/loginUser.dart';
import 'package:okados/config/config.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:http/http.dart' as http;

class ReSetPassword extends StatefulWidget {
  final String email;
  const ReSetPassword({Key? key, required this.email}) : super(key: key);

  @override
  State<ReSetPassword> createState() => _ReSetPasswordState();
}

class _ReSetPasswordState extends State<ReSetPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;
  bool showReassword = false;
  int? otp;

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
                      "Set Password",
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
                        _buildTextField(passwordController, "Password",
                            Icons.password, showPassword, () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildTextField(
                            repasswordController,
                            "Re Enter Password",
                            Icons.password,
                            showReassword, () {
                          setState(() {
                            showReassword = !showReassword;
                          });
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildSetPasswordButton(),
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
    IconData icon,
    bool isObscured,
    VoidCallback toggleVisibility,
  ) {
    return Container(
      child: TextField(
        controller: controller,
        obscureText: isObscured,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: secondaryColor,
          ),
          suffixIcon: InkWell(
            onTap: toggleVisibility,
            child: Icon(
              isObscured ? Icons.visibility_off : Icons.visibility,
            ),
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

  Widget _buildSetPasswordButton() {
    return Container(
      child: !isLoading
          ? ElevatedButton(
              onPressed: () => setPassrotd(),
              style: ElevatedButton.styleFrom(
                elevation: 20,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              child: const Text("Set Password", style: TextStyle(fontSize: 18)),
            )
          : const CircularProgressIndicator(
              color: whiteColor,
            ),
    );
  }

  setPassrotd() async {
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

    final reqBody = {
      "email": widget.email,
      "password": passwordController.text
    };

    try {
      final response = await http.post(
        Uri.parse(setPasswordApi),
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
        showSnackBar(context, "Please Enter Password");
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (response.statusCode == 200) {
        showSnackBar(context, "Password set Successfully");
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginUser()),
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
}

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}
