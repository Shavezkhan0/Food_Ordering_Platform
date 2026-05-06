import 'package:flutter/material.dart';
import 'package:okados/cart/cart_provider.dart';
import 'package:okados/navbar/navbar.dart';
import 'package:okados/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Okados',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Splash_Screen(),
        );
      }),
    );

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Okados',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   home: Splash_Screen(),
    // );
  }
}
