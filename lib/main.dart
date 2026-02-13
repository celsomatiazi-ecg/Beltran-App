import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/dependence_injection/dependence_injection.dart';
import '/ui/app_constants/app_style.dart';
import '/ui/auth/auth_options.dart';
import '/ui/auth/change_password.dart';
import '/ui/auth/device_auth.dart';
import '/ui/auth/forgot_password_screen.dart';
import '/ui/auth/login/login_screen.dart';
import '/ui/auth/login/security_code_screen.dart';
import '/ui/auth/signup/contact_data_screen.dart';
import '/ui/auth/signup/enterprise_data_screen.dart';
import '/ui/auth/signup/password_screen.dart';
import '/ui/auth/signup/person_data_screen.dart';
import '/ui/auth/signup/signup_message.dart';
import '/ui/auth/signup/signup_security_code_screen.dart';
import '/ui/home/client_detail_screen.dart';
import '/ui/home/home_screen.dart';
import '/ui/home/qr_code_screen.dart';
import '/ui/home/register_client_screen.dart';
import '/ui/menu/delete_account.dart';
import '/ui/menu/notification_screen.dart';
import '/ui/menu/registration_data.dart';
import '/ui/menu/security_privacy_screen.dart';
import '/ui/menu/terms_conditions.dart';
import '/ui/splash_screen/splash_screen.dart';

void main() {
  runApp(DependenceInjection(child: const MyApp()));

  //var storage = SecureStorageService();
  //storage.deleteAll();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff8B0100)),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppStyle.primaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(context.screenWidth, 52),
            backgroundColor: const Color(0xff8B0100),
            foregroundColor: Colors.white,
            textStyle: AppStyle.labelButton,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppStyle.primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black45),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black45),
          ),
        ),
      ),

      //initialRoute: "/home",
      initialRoute: "/splash_screen",
      routes: {
        "/splash_screen": (context) => const SplashScreen(),
        "/auth_options": (context) => const AuthOptions(),
        "/auth_login": (context) => const LoginScreen(),
        "/security_code": (context) => const SecurityCodeScreen(),
        "/device_auth": (context) => const DeviceAuth(),
        "/signup_person_data": (context) => const PersonDataScreen(),
        "/signup_enterprise_data": (context) => const EnterpriseDataScreen(),
        "/signup_contact_data": (context) => const ContactDataScreen(),
        "/signup_password": (context) => const PasswordScreen(),
        "/signup_security_code": (context) => const SignupSecurityCodeScreen(),
        "/signup_message": (context) => const SignupMessage(),
        "/change_password": (context) => const ChangePassword(),
        "/forgot_password": (context) => const ForgotPasswordScreen(),
        "/home": (context) => const HomeScreen(),
        "/client_detail": (context) => const ClientDetailScreen(),
        "/register_client": (context) => const RegisterClientScreen(),
        "/qr_code": (context) => const QrCodeScreen(),
        "/registration_data": (context) => const RegistrationData(),
        "/notifications": (context) => const NotificationScreen(),
        "/security_privacy": (context) => const SecurityPrivacyScreen(),
        "/delete_account": (context) => const DeleteAccount(),
        "/terms_conditions": (context) => const TermsConditions(),
      },
    );
  }
}
