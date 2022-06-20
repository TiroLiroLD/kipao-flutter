import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:kipao/assets/strings.dart';
import 'package:kipao/services/push_notification_service.dart';
import 'package:kipao/widgets/social_login.dart';

import '../assets/constants.dart';
import '../locator.dart';

class Welcome extends StatefulWidget {
  final FacebookLogin facebookAuth;

  const Welcome({required this.facebookAuth});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              sWelcome,
              style: kTitleTextStyle,
            ),
            //TODO: Add Image.asset(name),GestureDetector(
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                child: Text(
                  sSignIn,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onPressed: () => Navigator.pushNamed(context, '/signin'),
              ),
            ),
            Text('- Não tem uma conta? -'),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                child: Text(
                  sSignUp,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onPressed: () => Navigator.pushNamed(context, '/signup'),
              ),
            ),
            SocialLogin(
              facebook: widget.facebookAuth,
            ),
          ],
        ),
      ),
    );
  }
}
