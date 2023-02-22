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
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(loaderProduct.title),
      // ),
      body: CustomScrollView(
        //sliver is the scrollable area on the screen
        slivers: <Widget>[
          SliverAppBar(
            leading: const BackButton(
              color: Colors.orange,
            ),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loaderProduct.title,
                style:
                    TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
              background: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(ImageScreen.routeName,
                      arguments: [
                        loaderProduct.title,
                        loaderProduct.imageUrl,
                        loaderProduct.id
                      ]);
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: loaderProduct.id,
                      child: Image.network(
                        loaderProduct.imageUrl,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 2,
                        height: MediaQuery.of(context).size.width * 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              "\$${loaderProduct.price}",
              textAlign: TextAlign.center,
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
            ),
            SizedBox(
              height: 800,
            )
          ])),
        ],
      ),
    );
  }
}
