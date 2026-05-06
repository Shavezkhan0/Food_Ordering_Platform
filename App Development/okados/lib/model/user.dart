class ImageInfo {
  final String publicId;
  final String secureUrl;

  ImageInfo({
    required this.publicId,
    required this.secureUrl,
  });

  // Factory method to create an ImageInfo object from JSON
  factory ImageInfo.fromJson(Map<String, dynamic> json) {
    return ImageInfo(
      publicId: json['public_id'],
      secureUrl: json['secure_url'],
    );
  }

  // Method to convert an ImageInfo object to JSON
  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'secure_url': secureUrl,
    };
  }
}

class UserModel {
  final String? username;
  final List<ImageInfo> images;
  final String email;
  final int? phoneNumber;
  final String? password;
  final String address;
  final String landmark;
  final String pincode;
  final String city;
  final String state;
  final String country;

  UserModel({
    this.username,
    this.images = const [],
    required this.email,
    this.phoneNumber,
    this.password,
    this.address = '',
    this.landmark = '',
    this.pincode = '',
    this.city = '',
    this.state = '',
    this.country = '',
  });

  // Factory method to create a UserModel object from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      images: (json['image'] as List<dynamic>?)
              ?.map((image) => ImageInfo.fromJson(image))
              .toList() ??
          [],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      address: json['address'] ?? '',
      landmark: json['landmark'] ?? '',
      pincode: json['pincode'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }

  // Method to convert a UserModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'image': images.map((image) => image.toJson()).toList(),
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'address': address,
      'landmark': landmark,
      'pincode': pincode,
      'city': city,
      'state': state,
      'country': country,
    };
  }
}
