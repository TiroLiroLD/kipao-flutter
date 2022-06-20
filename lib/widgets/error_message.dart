import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final errorText;

  ErrorMessage({@required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Text(errorText,
        style: TextStyle(
            fontSize: 20, color: Colors.red[800], fontWeight: FontWeight.bold));
  }
}
