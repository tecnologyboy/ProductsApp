import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';

import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productServices = Provider.of<ProductService>(context);

    if (productServices.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products!!!'),
      ),
      body: ListView.builder(
        itemCount: productServices.productModelList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                productServices.selectedProduct =
                    productServices.productModelList[index].copy();
                Navigator.pushNamed(context, ProductScreen.routName);
              },
              child: ProductCards(
                productM: productServices.productModelList[index],
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            productServices.selectedProduct =
                ProductModel(available: false, name: '', price: 0);

            Navigator.pushNamed(context, ProductScreen.routName);
          }),
    );
  }
}
