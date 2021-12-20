import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';

class BottomPickerSheet extends StatelessWidget {
  final SizeHelper sizeHelper;

  final ThemeHelper themeHelper;
  final String title;
  final IconData icon;
  const BottomPickerSheet(
      {Key? key, required this.title, required this.themeHelper, required this.icon, required this.sizeHelper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizeHelper.width,
      height: sizeHelper.height! * 0.03,
      child: Row(
        children: [
          const Spacer(),
          Icon(icon, size: sizeHelper.height! * 0.03, color: themeHelper.primaryColor),
          SizedBox(
            height: sizeHelper.height! * 0.03,
            child: Center(
              child: AutoSizeText(title,
                  style: GoogleFonts.roboto(fontSize: sizeHelper.height! * 0.03, color: themeHelper.primaryColor)),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
