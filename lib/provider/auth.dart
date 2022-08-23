import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get userId{
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String URL) async {
    const  String apiKey='Enter Your Api';
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$URL?key=$apiKey');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
       _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
          _autoLogOut();
          notifyListeners();
          final pref=await SharedPreferences.getInstance();
          final userData=json.encode({'token':_token,'userId':_userId,'expiryDate':_expiryDate!.toIso8601String()});
          pref.setString('userData', userData);
      //print(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }
  Future<bool>tryAutoLogin()async{
    final pref=await SharedPreferences.getInstance();
    if(!pref.containsKey('userData')){
      return false;
    }
    final extractedData=json.decode(pref.getString('userData')!)as Map<String,dynamic>;
    final expiryDate=DateTime.parse(extractedData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token=extractedData['token'];
    _userId=extractedData['userId'];
    _expiryDate=expiryDate;
    notifyListeners();
    _autoLogOut();
    return true;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout()async{
    _token=null;
    _expiryDate=null;
    _userId=null;
    if(_authTimer!=null){
      _authTimer!.cancel();
      _authTimer=null;
    }
    notifyListeners();
    final pref= await SharedPreferences.getInstance();
    pref.clear();
  }
  void _autoLogOut(){
    if(_authTimer!=null){
      _authTimer!.cancel();
    }
    final timeToExpairy=_expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer=Timer(Duration(seconds: timeToExpairy), logout);
  }
}
