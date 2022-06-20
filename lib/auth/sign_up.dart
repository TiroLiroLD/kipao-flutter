import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:kipao/assets/constants.dart';
import 'package:kipao/assets/strings.dart';
import 'package:kipao/widgets/error_message.dart';
import 'package:kipao/widgets/social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../assets/constants.dart';

final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

String errorText = '';

class SignUp extends StatefulWidget {
  final FacebookLogin facebookAuth;

  const SignUp({required this.facebookAuth});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  late String _mail;
  late String _password;
  bool showSpinner = false;

  bool validLogin(String mail, String pass) =>
      (mail == 'teste@teste.com' && pass == '123456');

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
                Text(
                  sSignUp,
                  style: kTitleTextStyle,
                ),
                ErrorMessage(
                  errorText: errorText,
                ),
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                          decoration: const InputDecoration(hintText: sEmail),
                          validator: (String? value) => validateMail(value)),
                      TextFormField(
                          onChanged: (value) {
                            _password = value;
                          },
                          decoration:
                              const InputDecoration(hintText: sPassword),
                          validator: (String? value) =>
                              validatePassword(value)),
                      TextFormField(
                          decoration:
                              const InputDecoration(hintText: sConfirmPassword),
                          validator: (String? value) => confirmPassword(value)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () async => registerUser(),
                          child: const Text(('Submit')),
                        ),
                      )
                    ],
                  ),
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

  void registerUser() async {
    setState(() => errorText = '');
    if (_signUpFormKey.currentState!.validate()) {
      setState(() => showSpinner = true);
      try {
        //TODO:Check if newUser can be removed
        final newUser = await _auth.createUserWithEmailAndPassword(
          email: _mail,
          password: _password,
        );
        errorText = '';
        Navigator.pushNamed(context, '/');
      } on FirebaseAuthException catch (e) {
        // TODO
        setState(() {
          if (e.code == 'weak-password') errorText = firebaseErrorWeakPassword;
          if (e.code == 'invalid-email') errorText = firebaseErrorInvalidEmail;
          if (e.code == 'email-already-in-use')
            errorText = firebaseErrorEmailAlreadyInUse;
        });
        log('SignUp().registerUser()', error: e);
      } on Exception catch (e) {
        log('SignUp().registerUser()', error: e);
      }
      setState(() => showSpinner = false);
    }
  }

  String? validateMail(String? email) {
    if (email == null || email.isEmpty) return errorEmptyEmail;
    _mail = email.toString();
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return errorEmptyPassword;
    _password = password.toString();
    return null;
  }

  String? confirmPassword(String? password) {
    if (password == null || password.isEmpty) return errorEmptyPassword;
    if (password != _password) return errorPasswordWontMatch;
    return null;
  }
}
