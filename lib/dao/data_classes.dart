import 'package:realm/realm.dart'; // import realm package

//part 'data_classes.g.dart';

@RealmModel() // define a data model class named `_Session`.
class _Session {
  late String user;
  late String token; //JWT Token
  late String expires_at;
}

@RealmModel() // define a data model class named `_Cart` with properties as follows on json
/*
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
*/
class _Cart {
  //@RealmField(primaryKey: true) TODO: Implement primary key
  late int id;
  late double total;
  late double shippingFare;
  late List<_CartItem> items;
  late _PaymentMethod paymentMethod; //TODO: Implement _PaymentMethod Data Object class
  late String orderState;
  late String dateHour;
  late _Address address; //TODO: Implement _Address Data Object class
}

@RealmModel() // define a data model class named `_CartItem` with properties as follows on json
/*
  "product": {"id": 3},
  "quantity": 1,
  "unitPrice": 5.0,
  "totalPrice": 0.0,
  "personalizationOptions": [
    {"id": 4}
  ]
*/
class _CartItem {
  late _Product product; //TODO: Implement _Product Data Object class
  late int quantity;
  late double unitPrice;
  late double totalPrice;
  late List<_PersonalizationOption> personalizationOptions; //TODO: Implement _PersonalizationOption Data Object class
}