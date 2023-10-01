import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/product_service.dart';
import 'package:productos_app/widgets/product_image.dart';
import 'package:productos_app/Ui/input_decorations.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({
    super.key,
  });

  static String routName = 'Products';

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductFormBody(productService: productService),
    );
  }
}

class _ProductFormBody extends StatelessWidget {
  const _ProductFormBody({
    super.key,
    required this.productService,
  });

  final ProductService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  url: productService.selectedProduct.picture,
                ),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 40,
                          color: Colors.white,
                        ))),
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final PickedFile? pickerfile;

                          final image =
                              await picker.pickImage(source: ImageSource.gallery
                                  //source: ImageSource.camera
                                  );

                          if (image != null) {
                            pickerfile = PickedFile(image!.path);
                            print('We have local images ${image.path}');

                            productService
                                .updateSelectedProductImage(pickerfile.path);
                          } else {
                            print('Don\'t select nothing');
                          }
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.white,
                        ))),
              ],
            ),
            const _ProductForm(),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_outlined),
        onPressed: () async {
          productForm.isValidForm();

          final String? imageUrl = await productService.uploadImage();

          print(imageUrl);

          await productService.saveOrCreateProduct(productForm.product);
        },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    final produc = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: productForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: produc.name,
                  onChanged: (value) => produc.name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                  decoration: InputDecorations.authInputdecoration(
                      hintText: 'Product Name', labelText: 'Name:'),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: '${produc.price}',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (double.tryParse(value) == null) {
                      produc.price = 0;
                    } else {
                      produc.price = double.parse(value);
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputdecoration(
                      hintText: '\$150', labelText: 'Price:'),
                ),
                const SizedBox(
                  height: 30,
                ),
                SwitchListTile.adaptive(
                  value: produc.available,
                  title: const Text('Available'),
                  activeColor: Colors.indigo,
                  // onChanged: (value) {
                  //   productForm.productAvailability(value);
                  // },
                  /*
              Es valido pasar los metodos direct4amente, cuando la propiedad 
              y el metodo tienen la misma cantidad de parametros.
               */
                  onChanged: productForm.productAvailability,
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45)),
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                offset: const Offset(0, 5),
                color: Colors.black.withOpacity(0.05))
          ]);
}
