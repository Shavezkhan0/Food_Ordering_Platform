import 'package:okados/cart/cartPage.dart';
import 'package:okados/model/cart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + 'cart.db';
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE cart ('
        'sId TEXT PRIMARY KEY, '
        'title TEXT, '
        'shop TEXT, '
        'active TEXT, '
        'shopname TEXT, '
        'email TEXT, '
        'description TEXT, '
        'imagesInfo TEXT, '
        'category TEXT, '
        'foodCategory TEXT, '
        'price INTEGER, '
        'quantity INTEGER'
        ')');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await db;
    return await dbClient!.transaction((txn) async {
      await txn.insert('cart', cart.toMap());
      return cart;
    });
  }

  Future<List<Cart>> getCartList() async {
    var dbClient = await db;
    return await dbClient!.transaction((txn) async {
      final List<Map<String, dynamic>> queryResult = await txn.query('cart');
      return queryResult.map((e) => Cart.fromMap(e)).toList();
    });
  }

  Future<void> removeFromCart(String? sId) async {
    var dbClient = await db;
    await dbClient!.transaction((txn) async {
      await txn.delete(
        'cart',
        where: 'sId = ?',
        whereArgs: [sId],
      );
    });
  }

  void deleteCartItem(String? sId) async {
    try {
      DBHelper dbHelper = DBHelper();
      await dbHelper.removeFromCart(sId);
      print('Item with sId $sId has been removed from the cart.');
    } catch (e) {
      print('Failed to remove item: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      var dbClient = await db;
      if (dbClient != null) {
        await dbClient.delete('cart');
        print('All items have been removed from the cart.');
      } else {
        throw Exception('Database is not initialized');
      }
    } catch (e) {
      print('Failed to clear cart: $e');
    }
  }

  void clearCartItem() async {
    try {
      DBHelper dbHelper = DBHelper();
      await dbHelper.clearCart();
      print('All items have been removed from the cart.');
    } catch (e) {
      print('Failed to clear cart: $e');
    }
  }

  Future<void> increseQuantity(String? sId) async {
    var dbClient = await db;
    await dbClient!.update(
      'cart',
      {'quantity': (await getQuantity(sId)) + 1},
      where: 'sId = ?',
      whereArgs: [sId],
    );
  }

  Future<void> decreaseQuantity(String? sId) async {
    var dbClient = await db;
    await dbClient!.update(
      'cart',
      {'quantity': (await getQuantity(sId)) - 1},
      where: 'sId = ?',
      whereArgs: [sId],
    );
  }

  Future<int> getQuantity(String? sId) async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient!.query(
      'cart',
      columns: ['quantity'],
      where: 'sId = ?',
      whereArgs: [sId],
    );

    if (result.isNotEmpty) {
      return result.first['quantity'] as int;
    }
    return 0; // Default to 0 if the item doesn't exist
  }
}
