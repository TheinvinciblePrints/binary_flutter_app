class StringUtils {
  static String app_title = 'Binary App';
  static String favourites_title = 'Favourites';
  static String offline_title = 'Offline Mode';
  static String online_title = 'Online Mode';
  static String current_location_title = 'Current Location';
  static String subtitle = 'subtitle';
  static String title = 'title';
  static String filter = 'Filter by name or email or body';
  static String requestTimeout = 'Request timeout please refresh';
  static String noInternetConnection = 'No Internet Connection';
  static String noInternetSub = 'You are not connected to the internet.';
  static String noInternet =
      'Make sure Wi-Fi is on, Airplane Mode is off\n and try again';
  static String cityAdd = 'Add';

  static String enumName(String enumToString) {
    List<String> paths = enumToString.split(".");
    return paths[paths.length - 1];
  }
}
