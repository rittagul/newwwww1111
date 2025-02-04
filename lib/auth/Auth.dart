import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class IdItem {
  var Id;
  IdItem({required this.Id});
}

//كلاس من نوع اوث
class Auth with ChangeNotifier {
//ليست من نوع ادي ايتم لاضافة مستخدم جديد
  List<IdItem> addNewUser = [];
  String userId = '';
  String idToken = '';
  //المتغير الاخير يا تسجيل دخول يا انشاء حساب
  Future<void> _authenticate({
    required String email,
    required String password,
    required String urlSegment,
  }) async {
    final String urlApi =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDpciGCl20upQeAqgwtQdoRd-g9wDmJUYM';

    try {
      http.Response res = await http.post(
        Uri.parse(urlApi),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw '${resData['error']['message']}';
      }
      userId = resData['localId'];
      idToken = resData['idToken'];
      addNewUser.add(
        IdItem(
          Id: userId,
        ),
      );
      print('user Id ====' + userId);
      print('idToken Id ====' + idToken);
    } catch (_) {
      throw _;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(
        email: email, password: password, urlSegment: 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(
        email: email, password: password, urlSegment: 'signInWithPassword');
  }
}
