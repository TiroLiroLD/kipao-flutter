import 'package:realm/realm.dart'; // import realm package

//part 'data_classes.g.dart';

@RealmModel() // define a data model class named `_Session`.
class _Session {
  late String user;
  late String token; //JWT Token
  late String expires_at;
}
