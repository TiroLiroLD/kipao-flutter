import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:kipao/assets/config.dart';
//import 'package:kipao/assets/config.dart';
import 'package:kipao/assets/strings.dart';
import 'package:kipao/widgets/error_message.dart';
import 'package:kipao/widgets/social_login.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';

final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

String errorText = '';

class SignIn extends StatefulWidget {
  final FacebookLogin facebookAuth;

  const SignIn({required this.facebookAuth});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late String _email;
  late String _password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (debugMode)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            Provider.of<FirebaseAuth>(context, listen: false)
                                .signInAnonymously();
                            Navigator.pushNamed(context, '/');
                          },
                          child: const Text(('Skip')),
                        ),
                      )
                    : SizedBox.shrink(),
                Text(
                  sSignIn,
                  style: kTitleTextStyle,
                ),
                signInForm(),
                ErrorMessage(
                  errorText: errorText,
                ),
                SocialLogin(
                  facebook: widget.facebookAuth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signInForm() {
    return Form(
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
  }

  String? validateMail(String? email) {
    if (email == null || email.isEmpty) return 'Insira um email válido';
    // if (mail != formMail) return 'email não cadastrado';
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Insira uma senha válido';
    // if (password != formPass) return 'senha incorreta';
    return null;
  }

  void authUser() async {
    final firebaseAuth = Provider.of<FirebaseAuth>(context, listen: false);

    setState(() => errorText = '');
    if (_signInFormKey.currentState!.validate()) {
      setState(() => showSpinner = true);

      try {
        final user = await firebaseAuth.signInWithEmailAndPassword(
            email: _email, password: _password);
        Navigator.pushNamed(context, '/');
        //print(user);
        //print(user.user!.getIdToken());
      } on FirebaseAuthException catch (e) {
        // TODO
        setState(() {
          if (e.code == 'too-many-requests')
            errorText = firebaseErrorTooManyRequests;
          if (e.code == 'invalid-email' || e.code == 'wrong-password')
            errorText = firebaseErrorInvalidCredentials;
        });
        log('SignIn.authUser()', error: e);
      } on Exception catch (e) {
        log('SignUp().authUser()', error: e);
      }
    }
    setState(() => showSpinner = false);
  }

  void updateToken() {
    final firebaseAuth = Provider.of<FirebaseAuth>(context, listen: false);
    if (firebaseAuth.currentUser != null) {
      var uid = firebaseAuth.currentUser!.uid;
    }
  }
}
