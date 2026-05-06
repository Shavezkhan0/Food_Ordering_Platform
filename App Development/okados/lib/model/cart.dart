import 'dart:convert';

class Cart {
  String? sId;
  String? title;
  String? shop;
  String? active;
  String? shopname;
  String? email;
  String? description;
  List<ImageModel>? imagesInfo; // List of ImageModel
  String? category;
  String? foodCategory;
  int? price;
  int? quantity;

  Cart({
    this.sId,
    this.title,
    this.shop,
    this.active,
    this.shopname,
    this.email,
    this.description,
    this.imagesInfo,
    this.category,
    this.foodCategory,
    this.price,
    this.quantity,
  });

  Cart.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    shop = json['shop'];
    active = json['active'];
    shopname = json['shopname'];
    email = json['email'];
    description = json['description'];
    if (json['image'] != null) {
      imagesInfo = (json['image'] as List)
          .map((item) => ImageModel.fromJson(item))
          .toList();
    }
    category = json['category'];
    foodCategory = json['foodCategory'];
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toMap() {
    return {
      'sId': sId,
      'title': title,
      'shop': shop,
      'active': active,
      'shopname': shopname,
      'email': email,
      'description': description,
      'imagesInfo': jsonEncode(imagesInfo?.map((v) => v.toJson()).toList()),
      'category': category,
      'foodCategory': foodCategory,
      'price': price,
      'quantity': quantity,
    };
  }

  Cart.fromMap(Map<String, dynamic> map) {
    sId = map['sId'];
    title = map['title'];
    shop = map['shop'];
    active = map['active'];
    shopname = map['shopname'];
    email = map['email'];
    description = map['description'];
    imagesInfo = map['imagesInfo'] != null
        ? (jsonDecode(map['imagesInfo']) as List)
            .map((item) => ImageModel.fromJson(item))
            .toList()
        : null;
    category = map['category'];
    foodCategory = map['foodCategory'];
    price = map['price'];
    quantity = map['quantity'];
  }
}

class ImageModel {
  String? publicId;
  String? secureUrl;
  String? sId;

  ImageModel({this.publicId, this.secureUrl, this.sId});

  ImageModel.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'];
    secureUrl = json['secure_url'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'secure_url': secureUrl,
      '_id': sId,
    };
  }
}
