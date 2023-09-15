import 'package:flutter/material.dart';
import 'package:productos_app/models/producs_model.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProductModel product;

  ProductFormProvider(this.product);

  productAvailability(bool value) {
    product.available = value;
    print(product.available);
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
