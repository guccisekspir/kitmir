import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Color? color;
  final TextAlign? textAlign;
  final double? fontSize;
  const TitleWidget({Key? key, required this.title, this.color, this.textAlign, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper();
    SizeHelper sizeHelper = SizeHelper();
    return SizedBox(
      height: sizeHelper.height! * 0.05,
      width: sizeHelper.width! * 0.5,
      child: AutoSizeText(
        title,
        textAlign: textAlign ?? TextAlign.center,
        style: GoogleFonts.roboto(
          fontSize: fontSize,
          color: color ?? themeHelper.onBackground,
        ),
      ),
    );
  }
}
