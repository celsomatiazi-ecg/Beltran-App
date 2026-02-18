class HttpConstants {
  // ///TESTER
  // static String baseUrlOld = "http://34.248.70.59/api/v2";
  // static const String goaUrlRegistration  = 'http://34.248.70.59/auth/registration/';
  // static const String goaUrlLogin  = 'http://34.248.70.59/auth/login/';

  ///PRODUCTION
  static String baseUrlDX = "http://34.123.121.47:3001";

  ///Endpoints
  static String signup = "$baseUrlDX/user/";
  static String securityCode = "$baseUrlDX/user/code";
  static String password = "$baseUrlDX/user/password";
  static String login = "$baseUrlDX/auth/login";
  static String refresh = "$baseUrlDX/auth/refresh-token/";
  static String saveClient = "$baseUrlDX/client";
  static String clients = "$baseUrlDX/client/list";
  static String userData = "$baseUrlDX/user";
  static String updateUserData = "$baseUrlDX/user/update";
  static String updatePassword = "$baseUrlDX/user/update-password";
  static String clientCode = "$baseUrlDX/client/code";
  static String resendSecurityCode = "$baseUrlDX/user/code/resend";

  static String logout = "$baseUrlDX/token/logout/";
  static String forgot = "$baseUrlDX/request/";
}
