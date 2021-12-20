import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';
import 'package:kitmir/models/doge.dart';

class HealthInfoWidget extends StatelessWidget {
  final String healthResult;
  final String title;
  final double containerWidth;
  final double columnHeight;
  const HealthInfoWidget(
      {Key? key,
      required this.healthResult,
      required this.columnHeight,
      required this.title,
      required this.containerWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper();
    SizeHelper sizeHelper = SizeHelper();
    return SizedBox(
      width: containerWidth,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            AutoSizeText(
              title + ": ",
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntuMono(color: themeHelper.primaryColor, fontWeight: FontWeight.w700, fontSize: 15),
            ),
            Center(
                child: Text(
              healthResult,
              style: GoogleFonts.ubuntuMono(color: themeHelper.onBackground),
            )),
          ],
        ),
      ),
    );
  }
}
