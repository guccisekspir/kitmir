import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';
import 'package:kitmir/models/guide.dart';
import 'package:kitmir/widgets/titleWidget.dart';

class DetailedGuidePage extends StatelessWidget {
  final Guide currentGuide;
  const DetailedGuidePage({Key? key, required this.currentGuide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper();
    SizeHelper sizeHelper = SizeHelper();
    return Container(
      width: sizeHelper.width,
      height: sizeHelper.height,
      color: themeHelper.backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: BackButton(
                    color: Colors.white,
                  )),
              TitleWidget(title: currentGuide.name!),
              const SizedBox(
                height: 30,
              ),
              ...currentGuide.sections!
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: sizeHelper.height! * 0.05,
                              width: sizeHelper.width,
                              child: AutoSizeText(
                                e.title!,
                                style: GoogleFonts.roboto(
                                    color: themeHelper.secondaryColor, fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: sizeHelper.height!),
                              child: AutoSizeText(e.subtitle!),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
