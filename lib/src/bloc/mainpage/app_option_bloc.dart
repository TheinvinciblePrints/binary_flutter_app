import 'dart:async';

import 'package:binaryflutterapp/src/bloc/mainpage/app_option_provider.dart';

class AppOptionBloc {
  final optionController = StreamController();

  AppOptionProvider appOptionProvider = new AppOptionProvider();

  Stream get getOption => optionController.stream;

  void updateOption(int navigation) {
    appOptionProvider.updateSelectedOption(navigation);
    optionController.sink.add(appOptionProvider.currentOption);

    appOptionProvider.returnSelectedOption();
    optionController.sink.add(appOptionProvider.selectedOption);
  }

//  String getSelectedOption() {
//    return appOptionProvider.selectedOption;
//  }
//
//  Future saveOption(String value) async {
//    await sharedPref.saveSelectedOption(
//        CONSTANTS.SHARED_PREF_KEY_SELECTED_OPTION, value);
//  }
//
//  Future<void> getSharedPrefSavedOption() {
//    return sharedPref
//        .readSelectedOption(CONSTANTS.SHARED_PREF_KEY_SELECTED_OPTION);
//  }

  void dispose() {
    optionController.close();
  }
}

final bloc = AppOptionBloc();
