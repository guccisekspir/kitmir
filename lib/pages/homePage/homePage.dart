import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitmir/blocs/databaseBloc/bloc/database_bloc.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';
import 'package:kitmir/locator.dart';
import 'package:kitmir/models/doge.dart';
import 'package:kitmir/widgets/dogeSmallWidget.dart';
import 'package:kitmir/widgets/titleWidget.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseBloc databaseBloc = getIt<DatabaseBloc>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    yapAna();
  }

  yapAna() {
    firstlyDoges = [];

    for (var element in databaseBloc.dogeList!) {
      if (element.isFirst!) {
        firstlyDoges!.add(element);
      }
    }
  }

  static void preload(String path, BuildContext context) {
    var configuration = createLocalImageConfiguration(context);
    NetworkImage(path).resolve(configuration);
  }

  ThemeHelper themeHelper = ThemeHelper();
  SizeHelper sizeHelper = SizeHelper();

  List<String> bannerPath = [
    "assets/banners/bannerHasta.png",
    "assets/banners/bannerCins.png",
    "assets/banners/bannerEat.png",
    "assets/banners/bannerTest.png",
  ];

  List<Doge>? firstlyDoges;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeHelper.height,
      width: sizeHelper.width,
      color: themeHelper.backgroundColor,
      child: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: sizeHelper.height! * 0.3,
              child: CarouselSlider(
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    initialPage: 0,
                    aspectRatio: 3 / 4,
                    viewportFraction: 0.6,
                    height: sizeHelper.height! * 0.2),
                items: bannerPath.map((i) {
                  return Container(
                      width: sizeHelper.width! * 0.6,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.circular(40)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          i,
                          fit: BoxFit.fill,
                        ),
                      ));
                }).toList(),
              ),
            ),
            const TitleWidget(title: "Öne Çıkan Cinsler"),
            firstlyDoges != null
                ? SizedBox(
                    height: (sizeHelper.height! * 0.3) * (firstlyDoges!.length) / 2,
                    child: Wrap(
                      runSpacing: 10,
                      spacing: 15,
                      children: firstlyDoges!.map((e) => DogeSmallWidget(currentDoge: e)).toList(),
                    ))
                : const SizedBox(),
            const SizedBox(
              height: 200,
            )
          ],
        ),
      )),
    );
  }
}
