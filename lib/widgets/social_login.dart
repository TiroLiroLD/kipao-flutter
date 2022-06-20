/*import 'package:auth_buttons/auth_buttons.dart'
    show GoogleAuthButton, AuthButtonStyle, AuthButtonType, AuthIconType;*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:provider/provider.dart';

class SocialLogin extends StatefulWidget {
  final FacebookLogin facebook;

  const SocialLogin({required this.facebook});

  @override
  _SocialLoginState createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _email;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    //_updateLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('- OU -'),
          SizedBox(
            height: 20,
          ),
          Text('Entre com suas redes sociais'),
          SizedBox(
            height: 20,
          ),
          OutlinedButton(
            child: const Text('Log In'),
            onPressed: () => _signInWithFacebook(context),
          ),
        ],
      ),
    );
  }

/*

  Widget _buildUserInfo(BuildContext context, FacebookUserProfile profile,
      FacebookAccessToken accessToken, String? email) {
    final avatarUrl = _imageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (avatarUrl != null)
          Center(
            child: Image.network(avatarUrl),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('User: '),
            Text(
              '${profile.firstName} ${profile.lastName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Text('AccessToken: '),
        Text(
          accessToken.token,
          softWrap: true,
        ),
        if (email != null) Text('Email: $email'),
      ],
    );
  }
*/

  Future<Resource?> _signInWithFacebook(BuildContext context) async {
    try {
      final firebaseAuth = Provider.of<FirebaseAuth>(context, listen: false);
      final facebookAuth = Provider.of<FacebookAuth>(context, listen: false);
      final LoginResult result = await facebookAuth.login();
      switch (result.status) {
        case LoginStatus.success:
          print(result.accessToken!.token);
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);

          /// var facebookAuthCredential = FacebookAuthProvider.credential(accessToken);
          ///
          /// FirebaseAuth.instance.signInWithCredential(facebookAuthCredential)

          final userCredential =
              await firebaseAuth.signInWithCredential(facebookCredential);
          print(userCredential.credential!.token);
          Navigator.pushNamed(context, '/');
          return Resource(status: Status.Success);
        case LoginStatus.cancelled:
          return Resource(status: Status.Cancelled);
        case LoginStatus.failed:
          return Resource(status: Status.Error);
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
}

class Resource {
  final Status status;

  Resource({required this.status});
}

enum Status {
  Success,
  Error,
  Cancelled,
}
