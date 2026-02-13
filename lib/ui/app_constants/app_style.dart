import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class AppStyle {
  static Color primaryColor = Color(0xff1E1E1E);
  static Color secondaryColor = Color(0xff8B0100);

  static TextStyle labelButton = GoogleFonts.poppins(fontSize: 16);
  static TextStyle title = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleLight = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
