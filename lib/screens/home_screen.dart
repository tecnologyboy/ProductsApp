import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'Login';
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final producServices = Provider.of<ProductService>(context);

    if (producServices.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: ListView.builder(
        itemCount: producServices.productModelList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProductScreen.routName);
              },
              child: ProductCards(
                productM: producServices.productModelList[index],
              ));
        },
      ),
      floatingActionButton:
          FloatingActionButton(child: const Icon(Icons.add), onPressed: () {}),
    );
  }
}
