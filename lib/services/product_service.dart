import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductService extends ChangeNotifier {
  final _baseUrl = 'flutterproductsapp-a6192-default-rtdb.firebaseio.com';

  final List<ProductModel> productModelList = [];

  //TODO: Hacer fetch de productos
}
