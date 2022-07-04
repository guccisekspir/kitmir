import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitmir/helpers/listHelper.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';
import 'package:kitmir/models/guide.dart';
import 'package:kitmir/pages/diseasPage/detailedGuidePage.dart';

class DiseasePage extends StatefulWidget {
  const DiseasePage({Key? key}) : super(key: key);

  @override
  State<DiseasePage> createState() => _DiseasePageState();
}

class _DiseasePageState extends State<DiseasePage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  ThemeHelper themeHelper = ThemeHelper();
  SizeHelper sizeHelper = SizeHelper();
  TextStyle style = GoogleFonts.roboto(color: Colors.white);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: style,
      child: Container(
        height: sizeHelper.height,
        width: sizeHelper.width,
        color: themeHelper.backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              const Text("Rehber İçerikler"),
              SizedBox(
                height: sizeHelper.height! * 0.05,
                width: sizeHelper.width! * 0.6,
                child: TabBar(
                  controller: tabController,
                  tabs: [
                    Text(
                      "Yemek",
                      style: style,
                    ),
                    Text(
                      "Bakım",
                      style: style,
                    ),
                    Text(
                      "Eğitim",
                      style: style,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: sizeHelper.height! * 0.75,
                width: sizeHelper.width,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    SizedBox(
                      height: sizeHelper.height! * 0.75,
                      width: sizeHelper.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: ListView.builder(
                            itemCount: foodGuideList.length,
                            itemBuilder: (context, index) {
                              Guide currentGuide = foodGuideList[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailedGuidePage(
                                          currentGuide: currentGuide,
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    height: sizeHelper.height! * 0.2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.asset(
                                        currentGuide.bannerUrl!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    SizedBox(
                      height: sizeHelper.height! * 0.75,
                      width: sizeHelper.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: ListView.builder(
                            itemCount: groomGuidelist.length,
                            itemBuilder: (context, index) {
                              Guide currentGuide = groomGuidelist[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailedGuidePage(
                                          currentGuide: currentGuide,
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    height: sizeHelper.height! * 0.2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.asset(
                                        currentGuide.bannerUrl!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    SizedBox(
                      height: sizeHelper.height! * 0.75,
                      width: sizeHelper.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: ListView.builder(
                            itemCount: educationGuideList.length,
                            itemBuilder: (context, index) {
                              Guide currentGuide = educationGuideList[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailedGuidePage(
                                          currentGuide: currentGuide,
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    height: sizeHelper.height! * 0.2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.asset(
                                        currentGuide.bannerUrl!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
