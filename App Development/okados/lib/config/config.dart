import 'package:flutter/material.dart';

const jwt_secret = "Shavezkhan@44";

// const host = "http://192.168.0.198:8080";
// const host = "http://192.168.150.233:8080";
// const host = "http://192.168.198.233:8080";
const host = "http://localhost:3000";
// const host = "https://serverapk.okhladastarkhan.in";

//user
const loginApi = '$host/api/v1/user/login';
const userUpdateNamePhoneApi = '$host/api/v1/user/userUpdateNamePhone';
const userUpdateAddressApi = '$host/api/v1/user/userUpdateAddress';
const userUpdatePasswordApi = '$host/api/v1/user/userUpdatePassword';
const registerApi = '$host/api/v1/user/register';
const existApi = '$host/api/v1/user/exist';
const otpVerifyApi = '$host/api/v1/user/otpVerify';
const setPasswordApi = '$host/api/v1/user/setPassword';

//shops
const allShopsApi = '$host/api/v1/shop/allShops';

//order
const placeOrderApi = '$host/api/v1/order/placeOrder';
const userOrdersApi = '$host/api/v1/order/userOrders';
const byOrderIdApi = '$host/api/v1/order/byOrderId';

//Products
const allProductsApi = '$host/api/v1/product/allProducts';
const momoApi = '$host/api/v1/product/momo';
const chowmeinApi = '$host/api/v1/product/chowmein';
const friesApi = '$host/api/v1/product/fries';
const biryaniApi = '$host/api/v1/product/biryani';
const pizzaApi = '$host/api/v1/product/pizza';
const burgerApi = '$host/api/v1/product/burger';
const shawarmaApi = '$host/api/v1/product/shawarma';
const noodlesApi = '$host/api/v1/product/noodles';
const rollApi = '$host/api/v1/product/roll';
const nihariApi = '$host/api/v1/product/nihari';
const tikkaApi = '$host/api/v1/product/tikka';
const kormaApi = '$host/api/v1/product/korma';
const chickenfryApiApi = '$host/api/v1/product/chickenfry';
const rotiApi = '$host/api/v1/product/roti';
const search_by_idApi = '$host/api/v1/product/search_by_id';
const shopDetailsApi = '$host/api/v1/shop/byEmail';
const shopAllProducts = '$host/api/v1/product/shopProducts';

//api
const apikey1 = "AIzaSyDIKuuc0RHOEuTn6HDUP8vFMmwVQS_EWDw";
const apikey2 = "AIzaSyCIHRJ7ABROoUcISz-kJ3S7MFuFAVyJ6j4";
const goMapPro = "AlzaSyOMFYWgv--dFjgEJCPMC7ALXHhYfjM3AJQ";
const google_maps_API_KEY = "AIzaSyA9ph61POdUrMM_-oO_a8F1vUi8bK5d7ro";

//
const Color primaryColor = Color(0xFFB338D9);
const Color primaryBackgroundColor = Color.fromARGB(255, 204, 132, 226);
const Color secondaryColor = Color(0XFF6A1B9A);
const Color secondaryBackgroundColor = Color.fromARGB(255, 186, 97, 242);
const Color blueColor = Color(0xFFccf7f4);
const Color pinkColor = Color(0xFFf76cc6);
const Color voiletColor = Color(0xFFc471f2);
const Color orangeColor = Colors.orange;
const Color yellowColor = Colors.yellow;
const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
const Color greenColor = Colors.green;
const Color redColor = Colors.red;
const Color grayColor = Color.fromARGB(255, 228, 228, 228);
