class PageOptionProvider {
  int selectedindex = -1;
  int returnedindex = 0;

  void updateSelectedOption(int option) {
    selectedindex = option;
  }

  void returnSelectedOption() {
    if (selectedindex != -1) {
      returnedindex = selectedindex;
    }
  }
}
