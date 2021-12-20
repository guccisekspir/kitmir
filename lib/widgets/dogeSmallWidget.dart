import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';
import 'package:kitmir/models/doge.dart';
import 'package:kitmir/pages/dogeDetailPage.dart/dogeDetailPage.dart';
import 'package:kitmir/widgets/healthInfoWidget.dart';
import 'package:kitmir/widgets/kitmirNetworkImage.dart';

class DogeSmallWidget extends StatefulWidget {
  final Doge currentDoge;
  const DogeSmallWidget({Key? key, required this.currentDoge}) : super(key: key);

  @override
  State<DogeSmallWidget> createState() => _DogeSmallWidgetState();
}

class _DogeSmallWidgetState extends State<DogeSmallWidget> {
  ThemeHelper themeHelper = ThemeHelper();
  SizeHelper sizeHelper = SizeHelper();
  late double redContainerHeight = sizeHelper.height! * 0.2;
  late double topTitleHeight = (sizeHelper.height! * 0.07);
  late double containerWidth = sizeHelper.width! * 0.45;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSizes();
  }

  initSizes() {
    redContainerHeight = sizeHelper.height! * 0.2;
    topTitleHeight = (sizeHelper.height! * 0.07);
    containerWidth = sizeHelper.width! * 0.45;
  }

  @override
  Widget build(BuildContext context) {
    ThemeHelper themeHelper = ThemeHelper();
    SizeHelper sizeHelper = SizeHelper();
    double redContainerHeight = sizeHelper.height! * 0.2;
    double topTitleHeight = (sizeHelper.height! * 0.07);
    double containerWidth = sizeHelper.width! * 0.45;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => DogeDetailPage(currentDoge: widget.currentDoge),
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 1000),
            reverseTransitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: Container(
        height: sizeHelper.height! * 0.25,
        width: containerWidth,
        child: Stack(
          children: [
            Hero(
              tag: widget.currentDoge.id! + "container",
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: redContainerHeight,
                  decoration: BoxDecoration(
                    color: themeHelper.secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 8),
                          child: SizedBox(
                            height: topTitleHeight,
                            width: (sizeHelper.width! * 0.45) * 0.5,
                            child: AutoSizeText(
                              widget.currentDoge.name!,
                              wrapWords: false,
                              maxLines: 2,
                              style: GoogleFonts.ubuntuMono(
                                  color: themeHelper.onBackground, fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: (sizeHelper.height! * 0.07),
                          child: SizedBox(
                            height: redContainerHeight - topTitleHeight,
                            width: containerWidth,
                            child: Column(
                              children: [
                                const Spacer(),
                                HealthInfoWidget(
                                    columnHeight: redContainerHeight - topTitleHeight,
                                    containerWidth: containerWidth,
                                    healthResult: widget.currentDoge.health?.major?.length.toString() ?? "0",
                                    title: "Major Hastalık"),
                                HealthInfoWidget(
                                    columnHeight: redContainerHeight - topTitleHeight,
                                    containerWidth: containerWidth,
                                    healthResult: widget.currentDoge.health?.minor?.length.toString() ?? "0",
                                    title: "Minör Hastalık"),
                                HealthInfoWidget(
                                    columnHeight: redContainerHeight - topTitleHeight,
                                    containerWidth: containerWidth,
                                    healthResult: widget.currentDoge.health?.suggestedTest?.length.toString() ?? "0",
                                    title: "Önerilen Testler"),
                                const Spacer(),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Ayrıntılı bilgi",
                                        style: GoogleFonts.ubuntuMono(
                                            decoration: TextDecoration.underline, color: themeHelper.onBackground),
                                      ),
                                    ))
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Hero(
              tag: widget.currentDoge.id!,
              child: Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                    height: sizeHelper.height! * 0.12,
                    width: (sizeHelper.width! * 0.45) * 0.5,
                    child: KTNetworkImage(
                      imageURL: widget.currentDoge.smallPhoto!,
                      boxFit: BoxFit.fill,
                      isOval: false,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
