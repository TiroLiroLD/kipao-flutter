import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:kipao/assets/constants.dart';
import 'package:kipao/screens/custom_cake/cake_catalog.dart';
import 'package:kipao/screens/market/cart.dart';
import 'package:kipao/screens/market/catalog.dart';
import 'package:kipao/screens/orders.dart';
import 'package:kipao/screens/register_address.dart';
import 'package:kipao/screens/register_product.dart';
import 'package:kipao/screens/request_status.dart';
import 'package:kipao/screens/settings.dart';
import 'package:kipao/screens/subscription/subscription_options.dart';
import 'package:kipao/screens/subscription/subscription_cart.dart';
import 'package:kipao/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kipao/services/push_notification_service.dart';
import 'package:provider/provider.dart';

import 'auth/sign_up.dart';
import 'auth/sign_in.dart';
import 'locator.dart';
import 'models/custom_cake/cake_catalog.dart';
import 'models/market/cart.dart';
import 'models/market/catalog.dart';
import 'models/orders.dart';
import 'models/subscription/subscription_cart.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setupLocator();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  await _pushNotificationService.initialise();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final facebook = FacebookLogin(debug: true);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),
        Provider<FacebookAuth>(create: (_) => FacebookAuth.instance),
        Provider<CakeCatalogModel>(create: (_) => CakeCatalogModel()),
        Provider<CatalogModel>(create: (_) => CatalogModel()),
        Provider<OrdersModel>(create: (_) => OrdersModel()),
        /*ChangeNotifierProvider<SubscriptionCartModel>(
            create: (_) => SubscriptionCartModel()),*/
        ChangeNotifierProxyProvider<CatalogModel, SubscriptionCartModel>(
          create: (context) => SubscriptionCartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          accentColor: Colors.brown,
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.white),
          ),
        ),
        initialRoute: '/welcome',
        routes: {
          '/': (context) => Home(),
          '/welcome': (context) => Welcome(
                facebookAuth: facebook,
              ),
          '/signin': (context) => SignIn(
                facebookAuth: facebook,
              ),
          '/signup': (context) => SignUp(
                facebookAuth: facebook,
              ),
          '/settings': (context) => Settings(),
          '/requestStatus': (context) => RequestStatus(),
          '/catalog': (context) => CatalogPage(),
          '/customCake': (context) => CakeCatalogPage(),
          '/subscription': (context) => Subscription(),
          '/subscriptionCart': (context) => SubscriptionCart(),
          '/cart': (context) => MyCart(),
          '/orders': (context) => Orders(),
          '/registerProduct': (context) => RegisterProduct(),
          '/registerAddress': (context) => RegisterAddress(),
        },
      ),
    );
  }
}
