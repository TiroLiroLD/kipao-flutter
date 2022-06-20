// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kipao/models/requests.dart';

class CatalogModel {
  List<String> itemNames = [];
  Map<String, Object?> itemPrice = {};
  Map<String, int> itemId = {};

  void syncProducts() async {
    Response products = await getMarketProducts();
    itemNames = [];
    for (Map<String, Object?> product in (jsonDecode(products.body))) {
      if (product['metric'] == "Unitário") {
        itemNames.add(product['name'].toString());
        itemId[product['name'].toString()] = product['id'] as int;
        itemPrice[product['name'].toString()] = product['unitPrice'];
      }
    }
  }

  /// Get item by [id].
  ///
  /// In this sample, the catalog is infinite, looping over [itemNames].
  Item getById(int id) {
    return Item(id, itemNames[id], Icons.portrait_sharp,
        itemPrice[itemNames[id]] as double);
  }

  /// Get item by its position in the catalog.
  Item getByPosition(int position) {
    // In this simplified case, an item's position in the catalog
    // is also its id.
    return getById(position);
  }
}

@immutable
class Item {
  final int id;
  final String name;
  final IconData icon;
  final double price;

  Item(this.id, this.name, this.icon, this.price);

  // To make the sample app look nicer, each item is given one of the
  // Material Design primary colors.

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}
