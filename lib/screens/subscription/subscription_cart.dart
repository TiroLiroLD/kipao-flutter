// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:kipao/assets/strings.dart';
import 'package:kipao/models/market/cart.dart';
import 'package:kipao/models/orders.dart';
import 'package:kipao/models/subscription/subscription_cart.dart';
import 'package:kipao/widgets/kipao_scaffold.dart';
import 'package:provider/provider.dart';

class SubscriptionCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KipaoScaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                //child: _CartList(),
                child: _CartList(),
              ),
            ),
            const Divider(height: 4, color: Colors.black),
            _CartTotal()
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.headline6;
    var cart = context.watch<SubscriptionCartModel>();
    //var cart = context.watch<CartModel>();
    int option = cart.option;

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) => (cart.isInCart(cart.items[index]))
          ? ListTile(
              title: Text(
                cart.items[index].name,
                style: itemNameStyle,
              ),
            )
          : SizedBox.shrink(),
    );
  }
  /*return Text(
      "Plano $option itens",
      style: itemNameStyle,
    );
  }*/
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle =
        Theme.of(context).textTheme.headline1!.copyWith(fontSize: 48);
    var _cart = context.watch<SubscriptionCartModel>();
    final _orders = Provider.of<OrdersModel>(context, listen: false);

    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Another way to listen to a model's change is to include
            // the Consumer widget. This widget will automatically listen
            // to CartModel and rerun its builder on every change.
            //
            // The important thing is that it will not rebuild
            // the rest of the widgets in this build method.
            Consumer<SubscriptionCartModel>(
                builder: (context, cart, child) =>
                    Text('R\$${cart.totalPrice}', style: hugeStyle)),
            const SizedBox(width: 24),
            TextButton(
              onPressed: () async {
                placeOrder(context, _cart);
                _orders.syncOrders();
              },
              style: TextButton.styleFrom(primary: Colors.white),
              child: const Text(buy),
            ),
          ],
        ),
      ),
    );
  }

  void placeOrder(BuildContext context, SubscriptionCartModel cart) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text(placeOrderProcessing)));
    if (await cart.placeOrder()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(placeOrderSuccess)));
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(placeOrderError)));
    }
  }
}
