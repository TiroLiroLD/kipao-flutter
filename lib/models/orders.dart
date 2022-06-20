import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kipao/assets/constants.dart';
import 'package:kipao/models/requests.dart';
import 'package:kipao/widgets/kipao_scaffold.dart';

class OrdersModel extends ChangeNotifier {
  late Response _ordersResponse;

  late List<Map<String, Object?>> orders = [];
  late List<Widget> ordersInProgress = [];
  late List<Widget> ordersPending = [];
  late List<Widget> ordersCompleted = [];

  void syncOrders() async {
    _ordersResponse = await getOrders();
    ordersInProgress = [];
    ordersPending = [];
    ordersCompleted = [];
    for (Map<String, Object?> order in jsonDecode(_ordersResponse.body)) {
      if (order['orderState'].toString().toLowerCase() == 'em andamento')
        ordersInProgress.add(Order(order: order));
      if (order['orderState'].toString().toLowerCase() ==
          'aguardando confirmação') ordersPending.add(Order(order: order));
      if (order['orderState'].toString().toLowerCase() == 'finalizado')
        ordersCompleted.add(Order(order: order));
    }
  }
}

class Order extends StatelessWidget {
  final Map<String, Object?> order;

  const Order({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<Object?, Object?> address =
        order['address'] as Map<Object?, Object?>;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#' + order['id'].toString(),
                  style: kOrderStatusTextStyle,
                ),
                Text(
                  address['address'].toString() +
                      ', ' +
                      address['number'].toString(),
                  style: kOrderStatusTextStyle,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: products,
              ),
            )
          ],
        ),
      ),
    );
  }

  get products {
    List<Widget> products = [];
    for (var product in order['items'] as List)
      products.add(Container(
        color: products.length % 2 == 1 ? Colors.pink[50] : Colors.orange[50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product['quantity'].toString(),
              style: kOrderStatusTextStyle,
            ),
            Text(
              product['product']['name'].toString(),
              style: kOrderStatusTextStyle,
            ),
          ],
        ),
      ));
    return products;
  }
}
