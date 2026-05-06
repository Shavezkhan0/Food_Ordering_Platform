class ProductModel {
  String? sId;
  String? title;
  String? shop;
  String? active;
  String? shopname;
  String? email;
  String? description;
  List<ImageModel>? imagesInfo; // Changed to imagesInfo
  String? category;
  String? foodCategory;
  String? shopType;
  int? price;
  int? availability;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ProductModel({
    this.sId,
    this.title,
    this.shop,
    this.active,
    this.shopname,
    this.email,
    this.description,
    this.imagesInfo, // Use imagesInfo
    this.category,
    this.foodCategory,
    this.shopType,
    this.price,
    this.availability,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    shop = json['shop'];
    active = json['active'];
    shopname = json['shopname'];
    email = json['email'];
    description = json['description'];
    if (json['image'] != null) {
      imagesInfo = <ImageModel>[]; // Use imagesInfo
      json['image'].forEach((v) {
        imagesInfo!.add(ImageModel.fromJson(v)); // Use ImageModel
      });
    }
    category = json['category'];
    foodCategory = json['foodCategory'];
    shopType = json['shopType'];
    price = json['price'];
    availability = json['availability'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['shop'] = this.shop;
    data['active'] = this.active;
    data['shopname'] = this.shopname;
    data['email'] = this.email;
    data['description'] = this.description;
    if (this.imagesInfo != null) {
      data['image'] =
          this.imagesInfo!.map((v) => v.toJson()).toList(); // Use imagesInfo
    }
    data['category'] = this.category;
    data['foodCategory'] = this.foodCategory;
    data['shopType'] = this.shopType;
    data['price'] = this.price;
    data['availability'] = this.availability;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['public_id'] = this.publicId;
    data['secure_url'] = this.secureUrl;
    data['_id'] = this.sId;
    return data;
  }
}
