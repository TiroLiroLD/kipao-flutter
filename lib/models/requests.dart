import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:simple_logger/simple_logger.dart';
import '../assets/urls.dart';
import 'orders.dart';

final logger = SimpleLogger();

get bearerToken async =>
    await FirebaseAuth.instance.currentUser!.getIdToken(true);

//Recuperar Pedidos
Future<Response> getOrders() async => await get('/customer/orders');

//Recuperar Dados Cliente
Future<Response> getCustomer() async => await get('/customer/');

//Recuperar Todos os Pedidos
Future<Response> getProtectedOrders() async => await get('/protected/orders');

//Recuperar Produtos
Future<Response> getProducts() async => await get('/protected/products');

//Recuperar Produtos Mercado
Future<Response> getMarketProducts() async =>
    await get('/protected/products/market');

//Criar Pedido
Future<Response> createOrder(Map<String, Object?> jsonBody) async =>
    await put('/customer/order', jsonEncode(jsonBody));

//Criar Assinatura
Future<Response> createOrderSubscription(Map<String, Object?> jsonBody) async =>
    await put('/customer/orderSubscribe', jsonEncode(jsonBody));

//Criar Assinatura
Future<Response> createAddress(Map<String, Object?> jsonBody) async =>
    await put('/customer/address', jsonEncode(jsonBody));

//Criar Assinatura
Future<Response> registerProduct(Map<String, Object?> jsonBody) async =>
    await put('/protected/product', jsonEncode(jsonBody));

//Recuperar Dados Sessão
Future<Response> getSession() async {
  var token = await bearerToken;
  Response response = await http.post(
    Uri.parse('$requests/session/me'),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    },
  );
  //logger.info('POST /session/me STATUS CODE: ' + response.statusCode.toString() + response.body.toString());

  return response;
}

Future<Response> get(String endpoint) async {
  var token = await bearerToken;
  Response response = await http.get(
    Uri.parse('$requests$endpoint'),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    },
  );

  logger.info('GET $endpoint STATUS CODE: ' + response.statusCode.toString());

  print(token);

  return response;
}

Future<Response> getAddress(String postalCode) async {
  Response response = await http.get(
    Uri.parse('https://viacep.com.br/ws/$postalCode/json/'),
    headers: {},
  );
  return response;
}

Future<Response> put(String endpoint, jsonBody) async {
  var token = await bearerToken;
  Response response = await http.put(Uri.parse('$requests$endpoint'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.acceptHeader: "*/*",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonBody);

  logger.info('PUT $endpoint STATUS CODE: ' + response.statusCode.toString());

  return response;
}
