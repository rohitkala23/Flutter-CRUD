import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Padding + margin
const kPaddingMargin = EdgeInsets.all(20);

TextTheme textTheme = TextTheme(
  displayLarge: GoogleFonts.poppins(
      fontSize: 93, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  displayMedium: GoogleFonts.poppins(
      fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  displaySmall: GoogleFonts.poppins(fontSize: 46, fontWeight: FontWeight.w400),
  // Added as headline1
  headlineLarge: GoogleFonts.roboto(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  ),
  headlineMedium: GoogleFonts.poppins(
      fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineSmall: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w400),
  titleLarge: GoogleFonts.poppins(
      fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  // Modified as subtitle1
  titleMedium: GoogleFonts.poppins(
      fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
  titleSmall: GoogleFonts.poppins(
      fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: GoogleFonts.poppins(
      fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium: GoogleFonts.poppins(
      fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  labelLarge: GoogleFonts.poppins(
      fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  bodySmall: GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelSmall: GoogleFonts.poppins(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

ButtonStyle btnStyle(Color txtColor, Color bgColor) {
  return ButtonStyle(
    foregroundColor: WidgetStateProperty.all(txtColor),
    backgroundColor: WidgetStateProperty.all(bgColor),
  );
}
