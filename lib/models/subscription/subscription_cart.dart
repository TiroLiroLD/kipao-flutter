import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:kipao/models/market/catalog.dart';
import 'package:kipao/models/requests.dart';

class SubscriptionCartModel extends ChangeNotifier {
  /// The private field backing [catalog].
  late CatalogModel _catalog;

  /// Internal, private state of the cart. Stores the ids of each item.
  final List<int> _itemIds = [];

  /// Internal, private state of the cart. Stores the number of items.
  int _cartQuantity = 0;

  /// The current catalog. Used to construct items from numeric ids.
  CatalogModel get catalog => _catalog;

  final Map<String, int?> _itemQuantity = {};

  late int option;

  /// List of items in the cart.
  List<Item> get items => _itemIds.map((id) => _catalog.getById(id)).toList();

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  void setOption(int option) {
    this.option = option;
  }

  Map<int, double> optionPrice = {
    3: 15.0,
    5: 25.0,
    7: 35.0,
  };

  Map<int, int> optionId = {
    3: 128,
    5: 5,
    7: 129,
  };

  void increase(Item item) {
    if (_cartQuantity == option) return;
    _cartQuantity++;
    if (!_itemQuantity.keys.contains(item.name)) _itemQuantity[item.name] = 0;
    int? quantity = _itemQuantity[item.name];
    if (quantity != null) quantity++;
    _itemQuantity[item.name] = quantity;

    //totalPrice += item.price;
    if (!_itemIds.contains(item.id)) _itemIds.add(item.id);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void decrease(Item item) {
    int? quantity = _itemQuantity[item.name];
    if (quantity != null && quantity > 0) {
      quantity--;
      if (_cartQuantity != 0) _cartQuantity--;
    }
    if (quantity! < 0) quantity = 0;

    _itemQuantity[item.name] = quantity;
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  int? getCount(Item item) => (_itemQuantity[item.name]);

  /// The current total price of all items.
  double? get totalPrice => optionPrice[option];

  bool isInCart(Item item) {
    return _itemQuantity.containsKey(item.name) &&
        _itemQuantity[item.name] != 0;
  }

  Future<bool> placeOrder() async {
    List<Map<String, Object?>> _checkoutItems = [];
    Map<String, Object?> itemDetails = {};
    itemDetails["product"] = {"id": optionId[option]};
    itemDetails["quantity"] = 1;
    itemDetails["unitPrice"] = optionPrice[option];
    _checkoutItems.add(itemDetails);

    Map<String, Object?> jsonBodyOrder = {
      "total": totalPrice,
      "shippingFare": 0.0,
      "items": _checkoutItems,
      "paymentMethod": {"id": 6},
      "orderState": "Em andamento",
      "dateHour": DateTime.now().toString().split(' ')[0] +
          'T' +
          DateTime.now().toString().split(' ')[1],
      //TODO: Create User Provider to set address
      "address": {"id": 29}
    };

    Response order = await createOrder(jsonBodyOrder);

    if (order.statusCode == 200) {
      _cartQuantity = 0;
      _itemIds.clear();
      _itemQuantity.clear();
    }

    return order.statusCode == 200;
  }
}
