import 'package:flutter/material.dart';

class UserDataModel extends ChangeNotifier {
  Map<String, dynamic> userData = {};
  void setUserData(Map<String, dynamic> data) {
    userData.addAll(data);
    notifyListeners();
  }
}
