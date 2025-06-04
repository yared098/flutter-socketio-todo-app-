class AppConfig {
  static const String socketHost = '127.0.0.1';  // if not work , try 'localhost'
  static const int socketPort = 3000;  // change to your socket server port
  static String get socketUrl => 'http://$socketHost:$socketPort';
}
