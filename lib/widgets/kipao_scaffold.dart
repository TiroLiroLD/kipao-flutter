import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart';
import 'package:kipao/assets/constants.dart';
import 'package:provider/provider.dart';

import '../models/requests.dart';

class KipaoScaffold extends StatelessWidget {
  final Widget body;
  late final Response? session;

  KipaoScaffold({required this.body}) {
    setSession();
  }

  void setSession() async {
    session = await getSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kipão'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Início'),
                onTap: () =>
                    Navigator.popUntil(context, ModalRoute.withName('/')),
              ),
              ListTile(
                title: const Text('Monte seu bolo'),
                onTap: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  Navigator.pushNamed(context, '/customCake');
                },
              ),
              ListTile(
                title: const Text('Mercado'),
                onTap: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  Navigator.pushNamed(context, '/catalog');
                },
              ),
              ListTile(
                title: const Text('Plano de Pães e Doces'),
                onTap: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  Navigator.pushNamed(context, '/subscription');
                },
              ),
              ListTile(
                title: const Text('Pedidos Realizados'),
                onTap: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  Navigator.pushNamed(context, '/orders');
                },
              ),
              // ListTile(
              //   title: const Text('Monte seu bolo'),
              //   onTap: () {
              //     Navigator.popUntil(context, ModalRoute.withName('/'));
              //     Navigator.pushNamed(context, '/history');
              //   },
              // ),
              Divider(
                color: kPrimaryColor,
                thickness: 1,
              ),
              //TODO:Check user role
              ListTile(
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () async => _logout(context),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: body,
        ));
  }

  void _logout(BuildContext context) async {
    final firebaseAuth = Provider.of<FirebaseAuth>(context, listen: false);
    final facebookAuth = Provider.of<FacebookAuth>(context, listen: false);
    await firebaseAuth.signOut();
    await facebookAuth.logOut();
    Navigator.popUntil(context, ModalRoute.withName('/welcome'));
  }

/*void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }*/
}
