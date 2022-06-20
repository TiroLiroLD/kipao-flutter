import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:kipao/models/requests.dart';
import 'catalog.dart';

class CartModel extends ChangeNotifier {
  /// The private field backing [catalog].
  late CatalogModel _catalog;

  /// Internal, private state of the cart. Stores the ids of each item.
  final Map<String, int?> _itemQuantity = {};

  /// Internal, private state of the cart. Stores the # of each item.
  final List<int> _itemIds = [];

  /// The current catalog. Used to construct items from numeric ids.
  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  /// List of items in the cart.
  List<Item> get items => _itemIds.map((id) => _catalog.getById(id)).toList();

  /// The current total price of all items.
  double get totalPrice {
    double price = 0.0;
    for (int id in _itemIds) {
      double itemPrice =
          catalog.itemPrice[items[_itemIds.indexOf(id)].name] as double;
      int itemQuantity = _itemQuantity[items[_itemIds.indexOf(id)].name] as int;
      price += itemPrice * itemQuantity;
    }
    return price;
  }

  bool isInCart(Item item) {
    return _itemQuantity.containsKey(item.name) &&
        _itemQuantity[item.name] != 0;
  }

  void add(Item item) {
    _itemIds.add(item.id);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void increase(Item item) {
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
    if (quantity != null && quantity > 0) quantity--;
    if (quantity! < 0) quantity = 0;

    _itemQuantity[item.name] = quantity;
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  int? getCount(Item item) {
    return (_itemQuantity[item.name]);
  }

  void remove(Item item) {
    _itemIds.remove(item.id);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }

  Future<bool> placeOrder() async {
    List<Map<String, Object?>> _checkoutItems = [];
    for (Item item in items) {
      Map<String, Object?> itemDetails = {};
      itemDetails["product"] = {"id": catalog.itemId[item.name]};
      itemDetails["quantity"] = _itemQuantity[item.name];
      itemDetails["unitPrice"] = catalog.itemPrice[item.name];
      _checkoutItems.add(itemDetails);
    }

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
      _itemIds.clear();
      _itemQuantity.clear();
    }
    return order.statusCode == 200;
  }
}
