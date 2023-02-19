import 'package:flutter/foundation.dart';
import 'package:shoping_app/providers/product.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String userId;

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final Uri url = Uri.parse(
        'https://flutter-update-a0552-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'product': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList()
        }));

    if (total != 0) {
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts,
        ),
      );
    }

    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final Uri url = Uri.parse(
        'https://flutter-update-a0552-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == <String, dynamic>{}) {
      return;
    }

    extractedData.forEach((orderId, orderItem) {
      loadedOrders.add(
        OrderItem(
            id: orderId,
            amount: orderItem['amount'],
            dateTime: DateTime.parse(orderItem['dateTime']),
            products: (orderItem['product'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'] as String,
                    title: item['title'] as String,
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList()),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
