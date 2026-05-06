class Shop {
  String id;
  String username;
  String shop;
  String email;
  String phoneNumber;
  String password;
  String address;
  String landmark;
  String pincode;
  String city;
  String state;
  String country;
  List<Image> image;
  DateTime createdAt;
  DateTime updatedAt;

  Shop({
    required this.id,
    required this.username,
    required this.shop,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.address,
    required this.landmark,
    required this.pincode,
    required this.city,
    required this.state,
    required this.country,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['_id'],
      username: json['username'],
      shop: json['shop'],
      email: json['email'],
      phoneNumber: json['phoneNumber'].toString(),
      password: json['password'],
      address: json['address'],
      landmark: json['landmark'],
      pincode: json['pincode'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      image:
          (json['image'] as List).map((item) => Image.fromJson(item)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'shop': shop,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'address': address,
      'landmark': landmark,
      'pincode': pincode,
      'city': city,
      'state': state,
      'country': country,
      'image': image.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Image {
  String publicId;
  String secureUrl;
  String id;

  Image({
    required this.publicId,
    required this.secureUrl,
    required this.id,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      publicId: json['public_id'],
      secureUrl: json['secure_url'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'secure_url': secureUrl,
      '_id': id,
    };
  }
}
