import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class LanguageCubit extends Cubit<Locale> {
  final GetStorage _storage = GetStorage();

  LanguageCubit() : super(_loadInitialLocale());

  static Locale _loadInitialLocale() {
    String? savedLanguage = GetStorage().read('selectedLanguage');
    return Locale(savedLanguage ?? 'ru');
  }

  void setLanguage(String languageCode) {
    final Locale newLocale = Locale(languageCode);
    emit(newLocale);
    _storage.write('selectedLanguage', languageCode);
    Get.updateLocale(newLocale);
  }
}
