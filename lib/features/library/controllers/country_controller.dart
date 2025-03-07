import 'package:get/get.dart';
import 'package:maestro/data/models/country/country_model.dart';

class CountryController extends GetxController {
  Rx<CountryModel?> selectedCountry = Rx<CountryModel?>(null);

  void selectCountry(CountryModel country) {
    selectedCountry.value = country;
  }
}
