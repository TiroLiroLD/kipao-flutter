import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:kipao/assets/constants.dart';
import 'package:kipao/models/market/catalog.dart';
import 'package:kipao/models/orders.dart';
import 'package:kipao/models/requests.dart';
import 'package:kipao/widgets/kipao_scaffold.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    final _orders = Provider.of<OrdersModel>(context, listen: false);

    return KipaoScaffold(
      body: ListView(
        children: [
          _orders.ordersPending.length != 0
              ? Column(
                  children: [
                    Divider(
                      color: kPrimaryColor,
                      thickness: 2,
                    ),
                    Center(
                      child: Text(
                        'Aguardando Confirmação',
                        style: kOrderStatusTitleStyle,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _orders.ordersPending,
          ),
          _orders.ordersInProgress.length != 0
              ? Column(
                  children: [
                    Divider(
                      color: kPrimaryColor,
                      thickness: 2,
                    ),
                    Center(
                      child: Text(
                        'Em Andamento',
                        style: kOrderStatusTitleStyle,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _orders.ordersInProgress,
          ),
          _orders.ordersCompleted.length != 0
              ? Column(
                  children: [
                    Divider(
                      color: kPrimaryColor,
                      thickness: 2,
                    ),
                    Center(
                      child: Text(
                        'Finalizado',
                        style: kOrderStatusTitleStyle,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _orders.ordersCompleted,
          ),
        ],
      ),
    );
  }
}

class Order extends StatelessWidget {
  final Map<String, Object?> order;

  const Order({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('order');
  }
}
