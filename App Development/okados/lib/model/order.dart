import 'dart:convert';

class OrderModel {
  PaymentInfo? paymentInfo;
  Deliverystatus? deliverystatus;
  String? sId;
  String? orderId;
  String? username;
  String? email;
  int? phoneNumber;
  String? address;
  String? landmark;
  String? pincode;
  int? totalPrice;
  int? deliveryCharge;
  int? textCharge;
  Geolocation? geolocation;
  List<ShopDetails>? shopDetails;
  List<Products>? products;
  String? createdAt;
  String? updatedAt;
  int? iV;

  OrderModel(
      {this.paymentInfo,
      this.deliverystatus,
      this.sId,
      this.orderId,
      this.username,
      this.email,
      this.phoneNumber,
      this.address,
      this.landmark,
      this.pincode,
      this.totalPrice,
      this.deliveryCharge,
      this.textCharge,
      this.geolocation,
      this.shopDetails,
      this.products,
      this.createdAt,
      this.updatedAt,
      this.iV});

  OrderModel.fromJson(Map<String, dynamic> json) {
    paymentInfo = json['paymentInfo'] != null
        ? new PaymentInfo.fromJson(json['paymentInfo'])
        : null;
    deliverystatus = json['deliverystatus'] != null
        ? new Deliverystatus.fromJson(json['deliverystatus'])
        : null;
    sId = json['_id'];
    orderId = json['orderId'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    landmark = json['landmark'];
    pincode = json['pincode'];
    totalPrice = json['totalPrice'];
    deliveryCharge = json['deliveryCharge'];
    textCharge = json['textCharge'];
    geolocation = json['geolocation'] != null
        ? new Geolocation.fromJson(json['geolocation'])
        : null;
    if (json['shopDetails'] != null) {
      shopDetails = <ShopDetails>[];
      json['shopDetails'].forEach((v) {
        shopDetails!.add(new ShopDetails.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paymentInfo != null) {
      data['paymentInfo'] = this.paymentInfo!.toJson();
    }
    if (this.deliverystatus != null) {
      data['deliverystatus'] = this.deliverystatus!.toJson();
    }
    data['_id'] = this.sId;
    data['orderId'] = this.orderId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['pincode'] = this.pincode;
    data['totalPrice'] = this.totalPrice;
    data['deliveryCharge'] = this.deliveryCharge;
    data['textCharge'] = this.textCharge;
    if (this.geolocation != null) {
      data['geolocation'] = this.geolocation!.toJson();
    }
    if (this.shopDetails != null) {
      data['shopDetails'] = this.shopDetails!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class PaymentInfo {
  String? method;
  String? paymentStatus;

  PaymentInfo({this.method, this.paymentStatus});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    paymentStatus = json['paymentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    data['paymentStatus'] = this.paymentStatus;
    return data;
  }
}

class Deliverystatus {
  String? pack;
  String? shipped;
  String? deliver;

  Deliverystatus({this.pack, this.shipped, this.deliver});

  Deliverystatus.fromJson(Map<String, dynamic> json) {
    pack = json['pack'];
    shipped = json['shipped'];
    deliver = json['deliver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pack'] = this.pack;
    data['shipped'] = this.shipped;
    data['deliver'] = this.deliver;
    return data;
  }
}

class Geolocation {
  double? latitude;
  double? longitude;
  int? accuracy;
  String? sId;

  Geolocation({this.latitude, this.longitude, this.accuracy, this.sId});

  Geolocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    accuracy = json['accuracy'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['accuracy'] = this.accuracy;
    data['_id'] = this.sId;
    return data;
  }
}

class ShopDetails {
  String? shopemail;
  List<String>? products;
  String? sId;

  ShopDetails({this.shopemail, this.products, this.sId});

  ShopDetails.fromJson(Map<String, dynamic> json) {
    shopemail = json['shopemail'];
    products = json['products'].cast<String>();
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopemail'] = this.shopemail;
    data['products'] = this.products;
    data['_id'] = this.sId;
    return data;
  }
}

class Products {
  String? sId;
  String? title;
  String? shop;
  String? active;
  String? shopname;
  String? email;
  String? description;
  List<ImagesInfo>? imagesInfo;
  String? category;
  String? foodCategory;
  int? price;
  int? quantity;

  Products(
      {this.sId,
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
      this.quantity});

  Products.fromJson(Map<String, dynamic> json) {
    sId = json['sId'];
    title = json['title'];
    shop = json['shop'];
    active = json['active'];
    shopname = json['shopname'];
    email = json['email'];
    description = json['description'];

    // Check if imagesInfo is a string and parse it
    if (json['imagesInfo'] != null) {
      if (json['imagesInfo'] is String) {
        // Parse the JSON string into a List
        List<dynamic> parsedImages = jsonDecode(json['imagesInfo']);
        imagesInfo = parsedImages.map((v) => ImagesInfo.fromJson(v)).toList();
      } else if (json['imagesInfo'] is List) {
        // Directly process if it's already a List
        imagesInfo = json['imagesInfo']
            .map<ImagesInfo>((v) => ImagesInfo.fromJson(v))
            .toList();
      }
    }

    category = json['category'];
    foodCategory = json['foodCategory'];
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sId'] = this.sId;
    data['title'] = this.title;
    data['shop'] = this.shop;
    data['active'] = this.active;
    data['shopname'] = this.shopname;
    data['email'] = this.email;
    data['description'] = this.description;
    if (this.imagesInfo != null) {
      data['imagesInfo'] = this.imagesInfo!.map((v) => v.toJson()).toList();
    }
    data['category'] = this.category;
    data['foodCategory'] = this.foodCategory;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }
}

class ImagesInfo {
  String? publicId;
  String? secureUrl;
  String? sId;

  ImagesInfo({this.publicId, this.secureUrl, this.sId});

  ImagesInfo.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'];
    secureUrl = json['secure_url'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public_id'] = this.publicId;
    data['secure_url'] = this.secureUrl;
    data['_id'] = this.sId;
    return data;
  }
}
