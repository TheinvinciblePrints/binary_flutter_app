class AppOptionProvider {
  int currentOption = -1;

  String selectedOption = '';

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
}
