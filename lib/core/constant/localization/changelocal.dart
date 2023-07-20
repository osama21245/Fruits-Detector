import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:friuts_detector/core/constant/services/services.dart';

class LocaleController extends GetxController {
  Locale? language;

  MyServices myServices = Get.find();

  changeLang(String langcode) {
    Locale locale = Locale(langcode);
    myServices.sharedPreferences.setString("lang", langcode);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    language = const Locale("en");

    super.onInit();
  }
}
