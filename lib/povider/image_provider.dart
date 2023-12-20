// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
class songModelProvider with ChangeNotifier{
  int _id=0;
  int get id => _id;
  void setId (int id){
    _id =id;
    notifyListeners();
  }
}