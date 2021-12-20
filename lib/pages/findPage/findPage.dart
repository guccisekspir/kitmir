import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitmir/blocs/databaseBloc/bloc/database_bloc.dart';
import 'package:kitmir/helpers/classiferHelper.dart';
import 'package:kitmir/helpers/classifier.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';
import 'package:kitmir/locator.dart';
import 'package:kitmir/models/doge.dart';
import 'package:kitmir/pages/dogeDetailPage.dart/dogeDetailPage.dart';
import 'package:kitmir/pages/dogeDetailPage.dart/healthWidget.dart';
import 'package:kitmir/pages/findPage/bottomPickerSheet.dart';
import 'package:image/image.dart' as img;
import 'package:kitmir/widgets/dogeSmallWidget.dart';
import 'package:kitmir/widgets/kitmirNetworkImage.dart';
import 'package:kitmir/widgets/titleWidget.dart';

class FindPage extends StatefulWidget {
  const FindPage({Key? key}) : super(key: key);

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  ThemeHelper themeHelper = ThemeHelper();
  SizeHelper sizeHelper = SizeHelper();
  late Classifier _classifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _classifier = ClassifierFloat();
  }

  final picker = ImagePicker();

  Widget? selectedImage;
  String? predictedName;

  DatabaseBloc databaseBloc = getIt<DatabaseBloc>();
  TextEditingController breedController = TextEditingController();

  List<Doge> searchListDoge = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeHelper.backgroundColor,
      height: sizeHelper.height,
      width: sizeHelper.width,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleWidget(
                  title: "Köpeğinizin Fotoğrafını Yükleyin",
                  color: themeHelper.secondaryColor,
                  fontSize: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: sizeHelper.height! * 0.17,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final ImagePicker _picker = ImagePicker();

                                    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

                                    if (pickedFile != null) {
                                      var byts = await pickedFile.readAsBytes();
                                      setState(() {
                                        selectedImage = Image.memory(
                                          byts,
                                          fit: BoxFit.fill,
                                        );
                                      });
                                      _predict(File(pickedFile.path));
                                    }
                                  },
                                  child: BottomPickerSheet(
                                      title: "Camera",
                                      themeHelper: themeHelper,
                                      icon: Icons.camera_outlined,
                                      sizeHelper: sizeHelper),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                                    if (pickedFile != null) {
                                      Navigator.pop(context);
                                      var byts = await pickedFile.readAsBytes();
                                      setState(() {
                                        selectedImage = Image.memory(
                                          byts,
                                          fit: BoxFit.fill,
                                        );
                                      });
                                      _predict(File(pickedFile.path));
                                    }
                                  },
                                  child: BottomPickerSheet(
                                      title: "Gallery",
                                      themeHelper: themeHelper,
                                      icon: Icons.photo_library,
                                      sizeHelper: sizeHelper),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  height: sizeHelper.height! * 0.3,
                  width: sizeHelper.width! * 0.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: themeHelper.primaryColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      selectedImage != null ? Center(child: selectedImage!) : const SizedBox(),
                      Align(
                        alignment: selectedImage != null ? Alignment.topCenter : Alignment.center,
                        child: Icon(
                          Icons.add_a_photo,
                          color: themeHelper.primaryColor,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              predictedName != null
                  ? SizedBox(
                      height: sizeHelper.height! * 0.05,
                      width: sizeHelper.width! * 0.6,
                      child: Center(
                        child: AutoSizeText(
                          predictedName!,
                          style: GoogleFonts.roboto(color: themeHelper.secondaryColor, fontSize: 30),
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                height: predictedName != null ? sizeHelper.height! * 0.05 : 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("-- ya da --", style: GoogleFonts.roboto(color: themeHelper.onBackground)),
              ),
              Container(
                height: sizeHelper.height! * 0.05,
                width: sizeHelper.width! * 0.8,
                decoration: BoxDecoration(
                    color: themeHelper.backgroundColor.withGreen(100), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.search, color: themeHelper.onBackground),
                    ),
                    SizedBox(
                      height: sizeHelper.height! * 0.05,
                      width: sizeHelper.width! * 0.7,
                      child: TextFormField(
                        controller: breedController,
                        onChanged: (String? eben) {
                          searchListDoge.clear();

                          databaseBloc.dogeList!.forEach((element) {
                            if (element.name!.toLowerCase().contains(breedController.text.toLowerCase())) {
                              setState(() {
                                searchListDoge.add(element);
                              });
                            } else {}
                          });
                        },
                        style: GoogleFonts.roboto(color: themeHelper.onBackground),
                        decoration: const InputDecoration(hintText: "Cins ismini giriniz", border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: (sizeHelper.height! * 0.3) * (searchListDoge.length) / 2,
                  child: Wrap(
                    runSpacing: 10,
                    spacing: 15,
                    children: searchListDoge.map((e) => DogeSmallWidget(currentDoge: e)).toList(),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _predict(File image) async {
    img.Image imageInput = img.decodeImage(image.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);

    predictedName = pred.label;

    Doge? predictedDoge;

    databaseBloc.dogeList!.forEach((element) {
      if (element.name!.trim().toLowerCase() == predictedName!.trim().toLowerCase()) {
        predictedDoge = element;
        debugPrint("Eveeettt" + element.id!);
        debugPrint(predictedDoge!.health!.major!.toString());
      }
    });

    List<String> barNames = predictedDoge!.bars!.keys.toList();
    List<int>? barValues = predictedDoge!.bars!.values.toList();

    int healthRisk = 0;

    if (predictedDoge!.health!.major!.length > 0) {
      healthRisk++;
    }

    if (predictedDoge!.health!.minor!.length > 2) {
      healthRisk++;
    }
    if (predictedDoge!.health!.occasionally!.length > 2) {
      healthRisk++;
    }
    if (int.parse(predictedDoge!.health!.lifeSpan![0]) < 30) {
      healthRisk++;
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: sizeHelper.height! * 0.7,
            width: sizeHelper.width,
            color: Colors.transparent,
            child: Stack(
              children: [
                Hero(
                  tag: predictedDoge!.id! + "container",
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: sizeHelper.height! * 0.5,
                      width: sizeHelper.width,
                      color: themeHelper.backgroundColor,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (c, a1, a2) => DogeDetailPage(currentDoge: predictedDoge!),
                                        transitionsBuilder: (c, anim, a2, child) =>
                                            FadeTransition(opacity: anim, child: child),
                                        transitionDuration: const Duration(milliseconds: 1000),
                                        reverseTransitionDuration: const Duration(milliseconds: 400),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.arrow_upward,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: sizeHelper.height! * 0.15,
                            width: sizeHelper.width! * 0.6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  AutoSizeText(predictedDoge!.name!,
                                      style: GoogleFonts.roboto(color: themeHelper.secondaryColor, fontSize: 25)),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText("Sağlık riski: ",
                                        style: GoogleFonts.roboto(color: themeHelper.onBackground, fontSize: 20)),
                                  ),
                                  StarScore(
                                    score: healthRisk.toDouble(),
                                    star: Star(
                                        fillColor: themeHelper.primaryColor, emptyColor: Colors.grey.withAlpha(88)),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: sizeHelper.height! * 0.15,
                            child: SizedBox(
                              height: sizeHelper.height! * 0.3,
                              width: sizeHelper.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      HealthWidget(
                                          healthList: predictedDoge!.health!.major!, title: "Major hastalıklar"),
                                      HealthWidget(
                                          healthList: predictedDoge!.health!.minor!, title: "Minör hastalıklar"),
                                      HealthWidget(
                                          healthList: predictedDoge!.health!.occasionally!,
                                          title: "Seyrek hastalıklar"),
                                      HealthWidget(
                                          healthList: predictedDoge!.health!.suggestedTest!, title: "Önerilen Tesler"),
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
                                                          style: GoogleFonts.roboto(
                                                              color: themeHelper.onBackground, fontSize: 20)),
                                                    ),
                                                    StarScore(
                                                      score: barValues[barNames.indexOf(barNamesElemeent)].toDouble(),
                                                      star: Star(
                                                          fillColor: themeHelper.primaryColor,
                                                          emptyColor: Colors.grey.withAlpha(88)),
                                                    ),
                                                  ],
                                                ))
                                            .toList(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Hero(
                  tag: predictedDoge!.id!,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      height: sizeHelper.height! * 0.2,
                      width: sizeHelper.width! * 0.4,
                      child: KTNetworkImage(
                        imageURL: predictedDoge!.smallPhoto!,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });

    debugPrint(pred.label);
    debugPrint(pred.score.toString());
  }
}
