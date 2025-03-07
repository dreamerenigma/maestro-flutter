import 'package:flutter/material.dart';

class CountryModel {
  final String code;
  final String alphaCode;
  final String name;
  final String nativeName;
  final String flag;

  CountryModel(
    this.code,
    this.alphaCode,
    this.name,
    this.nativeName,
    this.flag,
  );

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'alphaCode': alphaCode,
      'name': name,
      'nativeName': nativeName,
      'flag': flag,
    };
  }

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      json['code'] as String? ?? '',
      json['alphaCode'] as String? ?? '',
      json['name'] as String? ?? '',
      json['nativeName'] as String? ?? '',
      json['flag'] as String? ?? '',
    );
  }
}

class SelectedCountryModel extends ChangeNotifier {
  String? selectedCountry;

  void updateCountry(String country) {
    selectedCountry = country;
    notifyListeners();
  }
}
