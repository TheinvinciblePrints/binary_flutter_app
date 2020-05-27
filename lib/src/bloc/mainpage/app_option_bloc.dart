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

  void dispose() {
    optionController.close();
  }
}

final bloc = AppOptionBloc();
