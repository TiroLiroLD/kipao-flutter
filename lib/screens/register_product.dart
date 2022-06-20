import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kipao/assets/strings.dart';
import 'package:kipao/models/custom_cake/cake_catalog.dart';
import 'package:kipao/models/market/catalog.dart';
import 'package:kipao/models/orders.dart';
import 'package:kipao/models/requests.dart';
import 'package:kipao/widgets/kipao_scaffold.dart';
import 'package:provider/provider.dart';

class RegisterProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<CakeCatalogModel>(context, listen: false).syncProducts();
    Provider.of<CatalogModel>(context, listen: false).syncProducts();
    Provider.of<OrdersModel>(context, listen: false).syncOrders();

    return KipaoScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [productForm()],
      ),
    );
  }
}

Widget productForm() {
  Map<String, String> product = {};

  return Form(
    child: Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(hintText: sProductName),
          onChanged: (value) {
            product['name'] = value.toString();
          },
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: sUnitPrice),
          onChanged: (value) {
            product['unitPrice'] = value.toString();
          },
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: sMetric),
          onChanged: (value) {
            product['metric'] = value.toString();
          },
        ),
        ElevatedButton(
          onPressed: () {
            registerProduct(product);
          },
          child: Text('Registrar'),
        ),
      ],
    ),
  );
}
/**
 *
    {
    "name" : "Guaraná Kuat",
    "unitPrice" : "6.00",
    "metric" : "Unitário"
    }


    Form(
    key: _signInFormKey,
    child: Column(
    children: [
    TextFormField(
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(hintText: sEmail),
    onChanged: (value) {
    _email = value;
    },
    validator: (String? value) => validateMail(value),
    ),
    TextFormField(
    obscureText: true,
    decoration: const InputDecoration(hintText: sPassword),
    onChanged: (value) {
    _password = value;
    },
    validator: (String? value) => validatePassword(value)),
    Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: ElevatedButton(
    onPressed: () async => authUser(),
    child: const Text(('Submit')),
    ),
    )
    ],
    ),
    );
 */
