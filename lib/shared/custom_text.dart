import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.textColor,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textDirection,
    this.letterSpacing,
    this.height,
  });

  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? letterSpacing;
  final double? height;
  final TextOverflow? overflow;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: textDirection ?? TextDirection.rtl,
      textAlign: textAlign ?? TextAlign.center,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: textColor ?? Colors.black,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        height: height,
      ),
    );
  }
}
