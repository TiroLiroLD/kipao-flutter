import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kipao/assets/strings.dart';
import 'package:kipao/models/custom_cake/cake_catalog.dart';
import 'package:kipao/models/market/catalog.dart';
import 'package:kipao/models/orders.dart';
import 'package:kipao/models/requests.dart';
import 'package:kipao/widgets/kipao_scaffold.dart';
import 'package:provider/provider.dart';

class RegisterAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<CakeCatalogModel>(context, listen: false).syncProducts();
    Provider.of<CatalogModel>(context, listen: false).syncProducts();
    Provider.of<OrdersModel>(context, listen: false).syncOrders();

    return KipaoScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [addressForm(context)],
      ),
    );
  }
}

Widget addressForm(BuildContext context) {
  Map<String, String> address = {};

  bool autoFill = false;

  String iAddress = '';
  String iAddressNumber = '';
  String iAddressNeighborhood = '';
  String iAddressCity = '';
  String iAddressState = '';

  void findAddress(String postalCode) async {
    Response a = await getAddress(postalCode);
    if (a.statusCode == 200) {
      print(a.body);
      autoFill = true;
    }
  }

  return Form(
    child: Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(hintText: sAddressPostalCode),
          onChanged: (postalCode) {
            address['postalCode'] = postalCode.toString();
            findAddress(postalCode);
          },
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: sAddress),
          onChanged: (value) {
            address['address'] = value.toString();
          },
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: sAddressNumber),
          onChanged: (value) {
            address['number'] = value.toString();
          },
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: sAddressNeighborhood),
          onChanged: (value) {
            address['neighborhood'] = value.toString();
          },
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: sAddressCity),
          onChanged: (value) {
            address['city'] = value.toString();
          },
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: sAddressState),
          onChanged: (value) {
            address['state'] = value.toString();
          },
        ),
        ElevatedButton(
          onPressed: () async {
            Response response = await createAddress(address);
            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Endereço cadastrado com sucesso!"),
              ));
              Navigator.popUntil(context, ModalRoute.withName('/'));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Ocorreu um erro ao cadastrar o endereço."),
              ));
            }
          },
          child: Text('Registrar'),
        ),
      ],
    ),
  );
}
