import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/models/models.dart';

class ProductService extends ChangeNotifier {
  final _baseUrl = 'flutterproductsapp-a6192-default-rtdb.firebaseio.com';

  final List<ProductModel> productModelList = [];

  bool isLoading = true;

  ProductService() {
    loadProducts();
  }

  Future<List<ProductModel>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');

    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final productTemp = ProductModel.fromJson(value);

      productTemp.id = key;

      productModelList.add(productTemp);
    });

    isLoading = false;
    notifyListeners();

    return productModelList;
  }
}
