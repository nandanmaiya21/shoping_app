import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/providers/products_provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;
  var _added = false;

  var _initValues = {
    'title': '',
    'discription': '',
    'price': '',
    'imageUrl': '',
  };
  EditedProduct _editedProduct = EditedProduct(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: 'imageUrl',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      _updateImageUrl();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;

      if (productId != null) {
        final product = Provider.of<Products>(context, listen: false)
            .findById(productId as String);

        _editedProduct = EditedProduct(
            id: product.id,
            title: product.title,
            description: product.description,
            imageUrl: product.imageUrl,
            price: product.price,
            isFavorite: product.isFavorite);

        _initValues = {
          'title': _editedProduct.title!,
          'discription': _editedProduct.description!,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };

        _imageUrlController.text = _editedProduct.imageUrl!;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForum() async {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      if (_editedProduct.id != '') {
        await Provider.of<Products>(context, listen: false).updateProduct(
            _editedProduct.id!,
            Product(
                id: _editedProduct.id!,
                title: _editedProduct.title!,
                description: _editedProduct.description!,
                price: _editedProduct.price!,
                imageUrl: _editedProduct.imageUrl!,
                isFavorite: _editedProduct.isFavorite!));

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: const Text('Product Updated!!')));

        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        try {
          await Provider.of<Products>(context, listen: false).addProduct(
              Product(
                  id: '',
                  title: _editedProduct.title!,
                  description: _editedProduct.description!,
                  price: _editedProduct.price!,
                  imageUrl: _editedProduct.imageUrl!));
          _added = true;
        } catch (error) {
          await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('An error occured!'),
              content: const Text('Something went wrong'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();

          if (_added) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Product Added!!'),
              ),
            );
          }
        }
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForum, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                        errorStyle: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct.title = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide title.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct.price = double.parse(value!);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Provide Price';
                        } else if (double.tryParse(value) == null) {
                          return 'Please enter valid number.';
                        } else if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['discription'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct.description = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide discription';
                        } else {
                          return null;
                        }
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForum();
                            },
                            onSaved: (value) {
                              _editedProduct.imageUrl = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
