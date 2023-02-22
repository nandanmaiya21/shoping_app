import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  static String routeName = '/image-screen';

  ImageScreen();

  @override
  Widget build(BuildContext context) {
    final List<String> data =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    final String imageUrl;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.orange,
        ),
        centerTitle: true,
        title: Text(
          data[0],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Hero(
            tag: data[2],
            child: Image.network(
              data[1],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
