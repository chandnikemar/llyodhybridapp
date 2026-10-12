// common_text.dart
// Place this file at: lib/widgets/common_text.dart
//
// Reusable text widget for the whole app.
//
// Fully dynamic — pass any fontSize / fontWeight / color you need directly:
//   CommonText('Custom label', fontSize: 15, fontWeight: FontWeight.w500)
//
// Or use the named presets below for consistency with the design spec.
// Presets can still be overridden per call if a screen needs a one-off tweak:
//   CommonText.h2('Section Title', color: AppColors.kPrimaryBlue)
//   CommonText.body('Note', fontSize: 15) // bumps size but keeps body's weight/color defaults
//
// Preset scale:
//   h1      22 / Bold
//   h2      16 / Medium
//   h3      14 / Medium
//   h4      12 / Regular
//   body    13 / Regular
//   caption 12 / Regular  (grey)
//   small   10 / Regular
//   tiny     8 / Regular

import 'package:flutter/material.dart';


import '../utilities/app_colors.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;

  /// Fully dynamic base constructor — define any size, weight, or color.
  const CommonText(
      this.text, {
        super.key,
        this.fontSize = 13,
        this.fontWeight = FontWeight.normal,
        this.color = AppColors.kTextDark,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.letterSpacing,
        this.height,
      });

  /// H1 — 22 / Bold (default). Override fontSize/fontWeight/color as needed.
  factory CommonText.h1(
      String text, {
        Key? key,
        double fontSize = 18,
        FontWeight fontWeight = FontWeight.bold,
        Color color = AppColors.kTextDark,
        TextAlign? textAlign,
        int? maxLines,
        TextOverflow? overflow,
      }) {
    return CommonText(
      text,
      key: key,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// H2 — 16 / Medium (default).
  factory CommonText.h2(
      String text, {
        Key? key,
        double fontSize = 16,
        FontWeight fontWeight = FontWeight.w500,
        Color color = AppColors.kTextDark,
        TextAlign? textAlign,
        int? maxLines,
        TextOverflow? overflow,
      }) {
    return CommonText(
      text,
      key: key,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// H3 — 14 / Medium (default).
  factory CommonText.h3(
      String text, {
        Key? key,
        double fontSize = 14,
        FontWeight fontWeight = FontWeight.w500,
        Color color = AppColors.kTextDark,
        TextAlign? textAlign,
        int? maxLines,
        TextOverflow? overflow,
      }) {
    return CommonText(
      text,
      key: key,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// H4 — 12 / Regular (default).
  factory CommonText.h4(
      String text, {
        Key? key,
        double fontSize = 12,
        FontWeight fontWeight = FontWeight.normal,
        Color color = AppColors.kTextDark,
        TextAlign? textAlign,
        int? maxLines,
        TextOverflow? overflow,
      }) {
    return CommonText(
      text,
      key: key,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Body — 13 / Regular (default).
  factory CommonText.body(
      String text, {
        Key? key,
        double fontSize = 13,
        FontWeight fontWeight = FontWeight.normal,
        Color color = AppColors.kTextDark,
        TextAlign? textAlign,
        int? maxLines,
        TextOverflow? overflow,
      }) {
    return CommonText(
      text,
      key: key,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Caption — 12 / Regular, grey by default.
  factory CommonText.caption(
      String text, {
        Key? key,
        double fontSize = 12,
        FontWeight fontWeight = FontWeight.normal,
        Color color = AppColors.kTextGrey,
        TextAlign? textAlign,
        int? maxLines,
        TextOverflow? overflow,
      }) {
    return CommonText(
      text,
      key: key,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Small — 10 / Regular (default).
  factory CommonText.small(
      String text, {
        Key? key,
        double fontSize = 10,
        FontWeight fontWeight = FontWeight.normal,
        Color color = AppColors.kTextDark,
        TextAlign? textAlign,
        int? maxLines,
        TextOverflow? overflow,
      }) {
    return CommonText(
      text,
      key: key,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Tiny — 8 / Regular (default).
  factory CommonText.tiny(
      String text, {
        Key? key,
        double fontSize = 8,
        FontWeight fontWeight = FontWeight.normal,
        Color color = AppColors.kTextDark,
        TextAlign? textAlign,
        int? maxLines,
        TextOverflow? overflow,
      }) {
    return CommonText(
      text,
      key: key,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      ),
    );
  }
}