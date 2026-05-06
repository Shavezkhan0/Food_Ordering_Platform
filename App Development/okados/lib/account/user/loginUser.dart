import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:okados/account/forgetpassword/forgetpassword.dart';
import 'package:okados/account/user/registerUser.dart';
import 'package:okados/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:okados/model/user.dart';
import 'package:okados/navbar/navbar.dart';
import 'package:okados/showBar/showBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool showPass = true;

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
              top: MediaQuery.of(context).size.height * 0.2,
            ),
            child: SingleChildScrollView(
              // Add SingleChildScrollView here
              child: Column(
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 30,
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: Column(
                      children: [
                        _buildTextField(
                            emailController, "Email", Icons.email, false),
                        const SizedBox(height: 25),
                        _buildTextField(passwordController, "Password",
                            Icons.password, true),
                        const SizedBox(height: 20),
                        _buildLoginButton(),
                        const SizedBox(height: 30),
                        _buildFooterButtons(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      IconData icon, bool isPassword) {
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
        obscureText: isPassword ? showPass : false,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: secondaryColor),
          suffixIcon: isPassword
              ? InkWell(
                  onTap: () {
                    setState(() {
                      showPass = !showPass;
                    });
                  },
                  child: Icon(
                    showPass ? Icons.visibility : Icons.visibility_off,
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

  Widget _buildLoginButton() {
    return Container(
      child: !isLoading
          ? ElevatedButton(
              onPressed: () => loginUser(),
              style: ElevatedButton.styleFrom(
                elevation: 20,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              child: const Text("Login", style: TextStyle(fontSize: 18)),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (contex) => RegisterUser()));
            },
            child: const Text(
              "Register",
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

  Future<void> loginUser() async {
    if (emailController.text.isEmpty) {
      showSnackBar(context, "Please Enter Email");
      return;
    }
    bool isvalidEmail = isValidEmail(emailController.text);
    if (!isvalidEmail) {
      showSnackBar(context, "Please Enter Valid Email");
      return;
    }
    if (passwordController.text.isEmpty) {
      showSnackBar(context, "Please Enter Password");
      return;
    }

    final reqBody = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(loginApi), // Ensure 'login' is defined correctly
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );

      if (response.statusCode == 400) {
        showSnackBar(context, "Please enter All required fields");
        setState(() {
          isLoading = false;
        });
      }

      if (response.statusCode == 404) {
        showSnackBar(context, "User Not Found");
        setState(() {
          isLoading = false;
        });
      }

      if (response.statusCode == 401) {
        showSnackBar(context, "Password Not Match");
        setState(() {
          isLoading = false;
        });
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("data : $data");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        final userJson = data['User'];
        UserModel user = UserModel.fromJson(userJson);
        await prefs.setString('User', jsonEncode(user.toJson()));
        showSnackBar(context, "User Login Successfully");
        setState(() {
          isLoading = false;
        });
        Navigator.push(
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
}

// isValidEmail
bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}
