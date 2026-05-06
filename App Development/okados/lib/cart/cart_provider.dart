import 'package:flutter/material.dart';
import 'package:okados/dataBase/db_helper.dart';
import 'package:okados/model/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  DBHelper db = DBHelper();

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  Future<List<Cart>> getCartData() async {
    _cart = db.getCartList();
    return _cart;
  }

  void _setPrefItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', _counter);
    prefs.setDouble('totalPrice', _totalPrice);
    notifyListeners();
  }

  void _getPrefItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('counter') ?? 0;
    _totalPrice = prefs.getDouble('totalPrice') ?? 0.0;
    notifyListeners();
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = totalPrice + productPrice;
    _setPrefItem();
    notifyListeners();
  }

  void removeFromTotalPrice(double productPrice) {
    _totalPrice = totalPrice - productPrice;
    if (_totalPrice < 0) {
      _totalPrice = 0;
    }
    _setPrefItem();
    notifyListeners();
  }

  void clearTotalPrice() {
    _totalPrice = 0;
    _setPrefItem();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefItem();
    return _totalPrice;
  }

  void addCounter() {
    _counter++;
    _setPrefItem();
    notifyListeners();
  }

  void removeCounter() {
    if (_counter > 0) {
      _counter--;
    }
    _setPrefItem();
    notifyListeners();
  }

  void resetCounter() {
    _counter = 0;
    _setPrefItem();
    notifyListeners();
  }

  int getCounter() {
    _getPrefItem();
    return _counter;
  }

  void increseQuantity(String sId) {
    db.increseQuantity(sId);
    notifyListeners();
  }

  void decresrQuantity(String sId) {
    db.decreaseQuantity(sId);
    notifyListeners();
  }

  void deleteItem(String sId) {
    db.deleteCartItem(sId);
    notifyListeners();
  }

  void clearCart() {
    _counter = 0;
    _totalPrice = 0;
    _setPrefItem();
    db.clearCartItem();
    notifyListeners();
  }
}
