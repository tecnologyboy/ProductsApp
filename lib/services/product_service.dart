import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/models/models.dart';

class ProductService extends ChangeNotifier {
  final _baseUrl = 'flutterproductsapp-a6192-default-rtdb.firebaseio.com';

  final List<ProductModel> productModelList = [];

  late ProductModel selectedProduct;

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

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

  Future saveOrCreateProduct(ProductModel product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await _createProduct(product);
    } else {
      await _updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> _updateProduct(ProductModel product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');

    final resp = await http.put(url, body: product.toRawJson());

    final decodeData = resp.body;

    final index =
        productModelList.indexWhere((element) => element.id == product.id);

    productModelList[index] = product;

    return product.id!;
  }

  Future<String> _createProduct(ProductModel product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    print(url);

    final resp = await http.post(url, body: product.toRawJson());

    final decodeData = json.decode(resp.body);

    product.id = decodeData['name'];

    print(decodeData);

    productModelList.add(product);

    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;

    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;

    this.isSaving = true;

    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/ddq78gyjv/image/upload?upload_preset=Product_App');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamUploadResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamUploadResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('There are an wrong');

      print(resp.body);

      print(resp.statusCode);

      return null;
    }

    this.newPictureFile = null;

    final decodeData = json.decode(resp.body);

    //print(decodeData);

    // print('***** Leo  ${decodeData['secure_url']}   Leo *****');

    print(selectedProduct.name);
    print(selectedProduct.price);
    print(selectedProduct..available);

    return decodeData['secure_url'];
  }
}
