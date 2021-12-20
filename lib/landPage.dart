import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitmir/blocs/databaseBloc/bloc/database_bloc.dart';
import 'package:kitmir/helpers/notificationHelper.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';
import 'package:kitmir/locator.dart';
import 'package:kitmir/pages/navigationPages.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class LandPage extends StatefulWidget {
  final bool isFirst;

  const LandPage({Key? key, required this.isFirst}) : super(key: key);
  @override
  _LandPageState createState() => _LandPageState();
}

//eğer giriş yapmamışsa

class _LandPageState extends State<LandPage> with SingleTickerProviderStateMixin {
  String? userID = "";

  bool isSharedLoaded = false;

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 10)
      ..animationDuration = const Duration(milliseconds: 10)
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..animationStyle = EasyLoadingAnimationStyle.scale
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType = EasyLoadingMaskType.custom
      ..indicatorSize = 45.0
      ..radius = 20.0
      ..progressColor = Colors.pinkAccent
      ..backgroundColor = Colors.white.withOpacity(0.1)
      ..indicatorColor = Colors.pinkAccent
      ..textColor = Colors.pinkAccent
      ..maskColor = Colors.black.withOpacity(0.7)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  late AnimationController animationController;

  //InitializerBloc initializerBloc = getIt<InitializerBloc>();

  Artboard? _splashArtboard;
  SMIBool? splashTrigger;

  NotificationHelper notificationHelper = getIt<NotificationHelper>();
  late DatabaseBloc databaseBloc;

  @override
  void initState() {
    databaseBloc = getIt<DatabaseBloc>();
    databaseBloc.add(GetDoges());
    rootBundle.load('assets/rives/droplasplash.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(artboard, 'droplaState');
        if (controller != null) {
          artboard.addController(controller);
        }
        setState(() => {_splashArtboard = artboard});
      },
    );
    //initializerBloc.add(StartInitializing());
    /*FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);*/
    configLoading();
    notificationHelper.initializeFCMNotification(context);
    notificationHelper.subscribeTopic("general");

    sharedFunction();

    super.initState();
  }

  //land pagede sadece eğer her şeyi yapmışsa homepage'e yönlendiriyoruz öteki türlü yine login page'e gidilcek ( çıkış yapmış olabilir, doldurmamış olabilir)
  @override
  Widget build(BuildContext context) {
    {
      if (isSharedLoaded) {
        //Shared gelene kadar userID null olduğu için burada o kontrolü yapıyoruz
        if ((widget.isFirst)) {
          debugPrint("Gidecek");
          SizeHelper(fetchedContext: context);

          Future.delayed(const Duration(milliseconds: 1500)).then((value) => {
                debugPrint("gidiyo"),
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => WithPages()), (Route<dynamic> route) => false);
                })
              });
        } else {}
      }

      return BlocListener<DatabaseBloc, DatabaseState>(
        bloc: databaseBloc,
        listener: (context, state) {
          if (state is DogesLoading) {
            debugPrint("laoding");
          } else if (state is DogesLoaded) {
            debugPrint("loaded");

            if (!widget.isFirst) {
              SizeHelper(fetchedContext: context);

              Future.delayed(const Duration(milliseconds: 3000)).then((value) => {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => NavigationPage()), (Route<dynamic> route) => false);
                    })
                  });
            }
          } else if (state is DogesLoadError) {
            debugPrint(state.errorCode);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Container(
              color: ThemeHelper().backgroundColor,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: SizeHelper().height,
                width: SizeHelper().width,
                child: _splashArtboard != null
                    ? RiveAnimation.asset(
                        "assets/rives/kitmirSplash.riv",
                        animations: ["Alltoghteher"],
                      )
                    : const SizedBox(),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> sharedFunction() async {
    debugPrint("shared geldi geldi");
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      //giriş yapıp yapmadığı kontrol ediliyor
      isSharedLoaded = true;
      if (prefs.getBool("isFirst") == null) {
        debugPrint("isfirst" + prefs.getBool("isFirst").toString());
        prefs.clear();
        prefs.setBool("isFirst", false);
        debugPrint("isfirst" + prefs.getBool("isFirst").toString());
      } else {
        if (prefs.getString("userID") != null) {
          userID = prefs.getString("userID");
          debugPrint("user geldi" + userID!);
          //if (userID != null) _databaseBloc.add(GetUser(userID!));
          //TODO checklensin authstate
        }
      }
    });
  }
}

class WithPages extends StatefulWidget {
  static final style = GoogleFonts.roboto(color: ThemeHelper().secondaryColor, fontSize: 30);

  @override
  _WithPages createState() => _WithPages();
}

class _WithPages extends State<WithPages> {
  int page = 0;
  late LiquidController liquidController;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  final pages = [
    Container(
      width: 800,
      color: ThemeHelper().backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: SizeHelper().height! * 0.3,
            width: SizeHelper().height! * 0.3,
            child: Image.asset(
              'assets/1.png',
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                "Köpeğiniz Doğuştan",
                style: WithPages.style,
              ),
              Text(
                "Hasta Olabilir",
                style: WithPages.style,
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      width: 800,
      color: const Color(0XFF29395E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: SizeHelper().height! * 0.3,
            width: SizeHelper().height! * 0.3,
            child: Image.asset(
              'assets/2.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                "Kıtmir sayesinde".tr(),
                style: WithPages.style,
              ),
              Text(
                "bu hastalıkları öğrenebilirsin".tr(),
                style: WithPages.style,
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      width: 800,
      color: const Color(0XFF1643AB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: SizeHelper().height! * 0.3,
            width: SizeHelper().height! * 0.3,
            child: Image.asset(
              'assets/3.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                "Hangi testler yaptırılmalı".tr(),
                style: WithPages.style,
              ),
              Text(
                "Neye dikkat edilmeli".tr(),
                style: WithPages.style,
              ),
              Text(
                "Kıtmirle hemen öğren!".tr(),
                style: WithPages.style,
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      width: 800,
      color: const Color(0XFF1D57DE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: SizeHelper().height! * 0.3,
            width: SizeHelper().height! * 0.3,
            child: Image.asset(
              'assets/4.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                "Kıtmir ile",
                style: WithPages.style,
              ),
              Text(
                "Sağlıklı",
                style: WithPages.style,
              ),
              Text(
                "Günlere",
                style: WithPages.style,
              ),
            ],
          ),
        ],
      ),
    ),
  ];

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - (page - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return Container(
      width: 25.0,
      child: Center(
        child: Material(
          color: ThemeHelper().primaryColor,
          type: MaterialType.circle,
          child: Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  SizeHelper sizeHelper = SizeHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: sizeHelper.width,
            height: sizeHelper.height,
            child: LiquidSwipe(
              pages: pages,
              positionSlideIcon: 0.8,
              slideIconWidget: Icon(
                Icons.arrow_back_ios,
                size: 40,
                color: ThemeHelper().primaryColor,
              ),
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              liquidController: liquidController,
              ignoreUserGestureWhileAnimating: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(pages.length, _buildDot),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => NavigationPage()), (route) => false);
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: sizeHelper.width! * 0.17,
                    maxWidth: sizeHelper.width! * 0.17,
                  ),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: AutoSizeText(
                      "Atla",
                      style: WithPages.style,
                    )),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  pageChangeCallback(int lpage) {
    debugPrint("page" + lpage.toString());
    setState(() {
      page = lpage;
    });
  }
}
