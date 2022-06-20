import 'package:flutter/material.dart';
import 'package:kipao/models/custom_cake/cake_catalog.dart';
import 'package:kipao/models/market/catalog.dart';
import 'package:kipao/models/orders.dart';
import 'package:kipao/widgets/kipao_scaffold.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Provider.of<CakeCatalogModel>(context, listen: false).syncProducts();
    Provider.of<CatalogModel>(context, listen: false).syncProducts();
    Provider.of<OrdersModel>(context, listen: false).syncOrders();

    return KipaoScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/customCake'),
            child: Text('Bolo Personalizado'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/catalog'),
            child: Text('Catálogo'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/subscription'),
            child: Text('Assinatura'),
          ),
        ],
      ),
    );
  }
}
