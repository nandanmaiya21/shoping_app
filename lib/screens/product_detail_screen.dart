import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/providers/product.dart';
import 'package:shoping_app/screens/image_screen.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    final loaderProduct =
        Provider.of<Products>(context, listen: false).findById(product.id);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
        centerTitle: true,
        title: Text(loaderProduct.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(ImageScreen.routeName,
                      arguments: [loaderProduct.title, loaderProduct.imageUrl]);
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      loaderProduct.imageUrl,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 2,
                      height: MediaQuery.of(context).size.width * 2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "\$${loaderProduct.price}",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 30,
                  fontFamily: 'Anton',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    loaderProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
