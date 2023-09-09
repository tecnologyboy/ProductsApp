import 'dart:convert';

class ProductModel {
  bool available;
  String name;
  String? picture;
  double price;
  String? id;

  ProductModel(
      {required this.available,
      required this.name,
      this.picture,
      required this.price,
      this.id});

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
      };
}
