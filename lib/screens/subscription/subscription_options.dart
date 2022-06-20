import 'package:flutter/material.dart';
import 'package:kipao/models/subscription/subscription_cart.dart';
import 'package:kipao/screens/subscription/subscription_catalog.dart';
import 'package:kipao/widgets/kipao_scaffold.dart';
import 'package:provider/provider.dart';

class Subscription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<SubscriptionCartModel>(context, listen: false);
    return KipaoScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => selectOption(context, _cart, 3),
            child: Text('3 Itens - R\$15,00'),
          ),
          ElevatedButton(
            onPressed: () => selectOption(context, _cart, 5),
            child: Text('5 Itens - R\$25,00'),
          ),
          ElevatedButton(
            onPressed: () => selectOption(context, _cart, 7),
            child: Text('7 Itens - R\$35,00'),
          ),
        ],
      ),
    );
  }

  void selectOption(BuildContext context, SubscriptionCartModel cart, int i) {
    cart.setOption(i);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SubscriptionCatalogPage()));
  }
}
