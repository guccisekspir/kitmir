import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';

class HealthWidget extends StatelessWidget {
  final List<String> healthList;
  final String title;
  const HealthWidget({Key? key, required this.healthList, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper();
    SizeHelper sizeHelper = SizeHelper();
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: AutoSizeText.rich(TextSpan(children: [
          TextSpan(text: "$title: ", style: GoogleFonts.roboto(color: themeHelper.secondaryColor, fontSize: 20)),
          ...healthList
              .map((e) =>
                  TextSpan(text: e + ", ", style: GoogleFonts.roboto(color: themeHelper.onBackground, fontSize: 15)))
              .toList()
        ])),
      ),
    );
  }
}
