import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kipao/models/requests.dart';
import 'package:kipao/widgets/kipao_scaffold.dart';

class RequestStatus extends StatefulWidget {
  @override
  _RequestStatusState createState() => _RequestStatusState();
}

String ordersCode = '';
String customerCode = '';
String protectedOrdersCode = '';
String productsCode = '';
String marketProductsCode = '';
String sessionCode = '';
String orderCode = '';
String orderSubscriptionCode = '';
String addressCode = '';
Map<String, Object?> jsonBodyOrderSubscription = {
  "total": 10.0,
  "shippingFare": 0.0,
  "items": [
    {
      "product": {"id": 3},
      "quantity": 1,
      "unitPrice": 5.0,
      "totalPrice": 0.0,
      "personalizationOptions": [
        {"id": 4}
      ]
    }
  ],
  "paymentMethod": {"id": 6},
  "orderState": "Em andamento",
  "dateHour": "2021-07-22T13:59:00.000+00:00",
  "recurring": "3 dias",
  "address": {"id": 29}
};

Map<String, Object?> jsonBodyOrder = {
  "total": 10.0,
  "shippingFare": 0.0,
  "items": [
    {
      "product": {"id": 3},
      "quantity": 1,
      "unitPrice": 5.0,
      "totalPrice": 0.0,
      "personalizationOptions": [
        {"id": 4}
      ]
    }
  ],
  "paymentMethod": {"id": 6},
  "orderState": "Em andamento",
  "dateHour": "2021-07-22T13:59:00.000+00:00",
  "address": {"id": 29}
};

Map<String, Object?> jsonBodyAddress = {
  "postalCode": "22290902",
  "address": "Av. Pasteur",
  "number": "250",
  "neighborhood": "Urca",
  "city": "Rio de Janeiro",
  "state": "RJ"
};

class _RequestStatusState extends State<RequestStatus> {
  @override
  Widget build(BuildContext context) {
    return KipaoScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              Response orders = await getOrders();
              setState(() {
                ordersCode = orders.statusCode.toString();
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Get Orders'),
                  Text(ordersCode),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Response customer = await getCustomer();
              setState(() {
                customerCode = customer.statusCode.toString();
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Get Customer'),
                  Text(customerCode),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Response protectedOrders = await getProtectedOrders();
              setState(() {
                protectedOrdersCode = protectedOrders.statusCode.toString();
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Get Protected Orders'),
                  Text(protectedOrdersCode),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Response products = await getProducts();
              setState(() {
                productsCode = products.statusCode.toString();
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Get Products'),
                  Text(productsCode),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Response marketProducts = await getMarketProducts();
              setState(() {
                marketProductsCode = marketProducts.statusCode.toString();
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Get Products Market'),
                  Text(marketProductsCode),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Response session = await getSession();
              setState(() {
                sessionCode = session.statusCode.toString();
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Get Session'),
                  Text(sessionCode),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Response order = await createOrder(jsonBodyOrder);
              setState(() {
                orderCode = order.statusCode.toString();
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Put Order'),
                  Text(orderCode),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Response orderSubscription =
                  await createOrderSubscription(jsonBodyOrderSubscription);
              setState(() {
                orderSubscriptionCode = orderSubscription.statusCode.toString();
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Put Order Subscription'),
                  Text(orderSubscriptionCode),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Response address = await createAddress(jsonBodyAddress);
              setState(() {
                addressCode = address.statusCode.toString();
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Put Create Address'),
                  Text(addressCode),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                ordersCode = '';
                customerCode = '';
                protectedOrdersCode = '';
                productsCode = '';
                marketProductsCode = '';
                sessionCode = '';
                orderCode = '';
                orderSubscriptionCode = '';
                addressCode = '';
              });
            },
            child: Container(child: Icon(Icons.restore)),
          ),
        ],
      ),
    );
  }
}
