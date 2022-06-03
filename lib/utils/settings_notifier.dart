import 'package:flutter/material.dart';

class SettingsNotifier extends ChangeNotifier {
  bool _editCity = false;
  String _city = "Samarinda";
  bool _isMetric = false;
  String _language = "English";
  List<bool> isOpen = [false, false, false];

  bool get editCity => _editCity;

  String get city => _city;

  bool get isMetric => _isMetric;

  String get language => _language;

  void changeIsOpen(int index, bool value){
    isOpen[index] = value;
    notifyListeners();
  }

  set editCity(bool value) {
    _editCity = value;
    notifyListeners();
  }

  set city(String value) {
    _city = value;
    notifyListeners();
  }

  set isMetric(bool value) {
    _isMetric = value;
    notifyListeners();
  }

  set language(String value) {
    _language = value;
    notifyListeners();
  }
}