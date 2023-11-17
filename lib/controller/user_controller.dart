import 'package:firebase_auth/firebase_auth.dart';

import '../data/user_db_provider.dart';

class UserController{
  
  final UserDbProvider userDbProvider;

  int? userId;
  String? userName;
  String? email;
  String? password;
  bool? logged_in;

  UserController(this.userDbProvider);

  // Future save() async{
  //   User user;
  //   user!.displayName = userName;
  //   user!.email = email; 
  //   this.userDbProvider.insert(, password);
  // }

}