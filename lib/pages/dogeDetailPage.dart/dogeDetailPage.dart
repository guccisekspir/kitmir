import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';
import 'package:kitmir/models/doge.dart';
import 'package:kitmir/pages/dogeDetailPage.dart/healthWidget.dart';
import 'package:kitmir/widgets/kitmirNetworkImage.dart';
import 'package:kitmir/widgets/titleWidget.dart';

class DogeDetailPage extends StatelessWidget {
  final Doge currentDoge;
  const DogeDetailPage({Key? key, required this.currentDoge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper();
    SizeHelper sizeHelper = SizeHelper();
    List<String> barNames = currentDoge.bars!.keys.toList();
    List<int>? barValues = currentDoge.bars!.values.toList();
    return Container(
      height: sizeHelper.height,
      width: sizeHelper.width,
      color: Colors.black,
      child: Stack(
        children: [
          Hero(
            tag: currentDoge.id! + "container",
            child: Container(
              height: sizeHelper.height,
              width: sizeHelper.width,
              color: themeHelper.backgroundColor,
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: BackButton(
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Hero(
                tag: currentDoge.id!,
                child: SizedBox(
                  height: sizeHelper.height! * 0.2,
                  width: sizeHelper.width! * 0.4,
                  child: KTNetworkImage(
                    imageURL: currentDoge.fullPhoto!,
                    isOval: false,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: sizeHelper.height! * 0.2 + MediaQuery.of(context).padding.top,
            child: SizedBox(
              width: sizeHelper.width,
              height: sizeHelper.height! * 0.7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            currentDoge.name!,
                            style: GoogleFonts.ubuntuMono(
                                color: themeHelper.secondaryColor, fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: sizeHelper.height! * 0.1,
                          ),
                          child: AutoSizeText(
                            currentDoge.description!,
                            style: GoogleFonts.roboto(color: themeHelper.onBackground),
                          ),
                        ),
                      ),
                      TitleWidget(
                        title: "Sağlık",
                        fontSize: 30,
                        color: themeHelper.secondaryColor,
                      ),
                      HealthWidget(healthList: currentDoge.health!.major!, title: "Major hastalıklar"),
                      HealthWidget(healthList: currentDoge.health!.minor!, title: "Minör hastalıklar"),
                      HealthWidget(healthList: currentDoge.health!.occasionally!, title: "Seyrek hastalıklar"),
                      HealthWidget(healthList: currentDoge.health!.suggestedTest!, title: "Önerilen Tesler"),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: barNames
                            .map((barNamesElemeent) => Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(barNamesElemeent,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(color: themeHelper.onBackground, fontSize: 20)),
                                    ),
                                    StarScore(
                                      score: barValues[barNames.indexOf(barNamesElemeent)].toDouble(),
                                      star: Star(
                                          fillColor: themeHelper.primaryColor, emptyColor: Colors.grey.withAlpha(88)),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            "Bakım",
                            style: GoogleFonts.ubuntuMono(
                                color: themeHelper.secondaryColor, fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: sizeHelper.height! * 0.1,
                          ),
                          child: AutoSizeText(
                            currentDoge.upkeep!,
                            style: GoogleFonts.roboto(color: themeHelper.onBackground),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            "Huy",
                            style: GoogleFonts.ubuntuMono(
                                color: themeHelper.secondaryColor, fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: sizeHelper.height! * 0.1,
                          ),
                          child: AutoSizeText(
                            currentDoge.temperament!,
                            style: GoogleFonts.roboto(color: themeHelper.onBackground),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
