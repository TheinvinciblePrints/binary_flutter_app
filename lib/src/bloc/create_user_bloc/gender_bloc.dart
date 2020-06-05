import 'dart:async';

class GenderBloc {
  final genderController = StreamController();

  GenderProvider genderProvider = new GenderProvider();

  Stream get getOption => genderController.stream;

  void updateOption(int option) {
    genderProvider.updateSelectedOption(option);
    genderController.sink.add(genderProvider.currentOption);

    genderProvider.returnSelectedOption();
    genderController.sink.add(genderProvider.selectedOption);
  }

  void getGenderFromDB(String gender) {
    if (gender != null) {
      if (gender == "Male") {
        updateOption(0);
      } else {
        updateOption(1);
      }
    }
  }

  String getSelectedOption() {
    return genderProvider.selectedOption;
  }

  void dispose() {
    genderController.close();
  }
}

class GenderProvider {
  int currentOption = -1;

  String selectedOption = '';

  void updateSelectedOption(int option) {
    currentOption = option;
  }

  void returnSelectedOption() {
    if (currentOption != 1) {
      selectedOption = 'Male';
    } else {
      selectedOption = 'Female';
    }
  }
}

final genderBloc = GenderBloc();
