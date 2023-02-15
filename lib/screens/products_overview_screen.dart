import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart' as bd;
import '../providers/cart.dart';
import '../providers/products_provider.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context, listen: false)
    //     .fetchAndSetProducts(); //WILL WORK if you set listen to false

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOption selectedValue) => setState(() {
              if (selectedValue == FilterOption.Favorites) {
                _showOnlyFavorites = true;
              } else {
                _showOnlyFavorites = false;
              }
            }),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                bd.Badge(child: ch!, value: cart.itemCount.toString()),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  // backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
            )
          : ProductGrid(_showOnlyFavorites),
    );
  }
}
