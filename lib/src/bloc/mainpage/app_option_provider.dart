import 'package:binaryflutterapp/src/utils/shared_pref.dart';
import 'package:binaryflutterapp/src/utils/shared_pref_constants.dart';

class AppOptionProvider {
  int currentOption = -1;

  String selectedOption = '';
  String savedMode = '';

  SharedPref sharedPref = SharedPref();

  void updateSelectedOption(int option) {
    currentOption = option;
  }

  void returnSelectedOption() {
    if (currentOption != 1) {
      selectedOption = 'Offline';
    } else {
      selectedOption = 'Online';
    }
  }

  Future getSavedOption() {
    return sharedPref
        .readSelectedOption(CONSTANTS.SHARED_PREF_KEY_SELECTED_OPTION);
  }

  void returnSavedMode() {
    getSavedOption().then((value) => {
          //print('selectedOption ${value}')
          savedMode = value
        });
  }
}
