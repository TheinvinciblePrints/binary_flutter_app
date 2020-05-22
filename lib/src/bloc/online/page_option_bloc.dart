import 'dart:async';

import 'package:binaryflutterapp/src/bloc/online/page_option_provider.dart';

class PageOptionBloc {
  final pageController = StreamController();

  PageOptionProvider pageOptionProvider = new PageOptionProvider();

  Stream get getPage => pageController.stream;

  final _isSelected = <bool>[true, false];

  void updateOption(int option) {
    pageOptionProvider.updateSelectedOption(option);
    pageController.sink.add(pageOptionProvider.selectedindex);

    pageOptionProvider.returnSelectedOption();
    pageController.sink.add(pageOptionProvider.returnedindex);
  }

  List<bool> isSelected() {
    for (int i = 0; i < _isSelected.length; i++) {
      _isSelected[i] = i == pageOptionProvider.returnedindex;
    }

    return _isSelected;
  }

  void dispose() {
    pageController.close();
  }
}
