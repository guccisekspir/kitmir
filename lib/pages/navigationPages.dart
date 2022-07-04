// ignore_for_file: unused_field

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitmir/blocs/navBarbBloc.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';
import 'package:kitmir/pages/diseasPage/diseasPage.dart';
import 'package:kitmir/pages/findPage/findPage.dart';
import 'package:kitmir/pages/homePage/homePage.dart';

import 'package:rive/rive.dart' hide LinearGradient;
import 'package:shared_preferences/shared_preferences.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({
    Key? key,
  }) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        debugPrint('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        if (activeIndex == 1) {
          triggers[activeIndex]?.change(false);
          triggers[2]?.change(true);
          activeIndex = 2;
          _bottomNavBarBloc.pickItem(2);
        }

        //rebuildAllChildren();

        /// _coreApiBloc.add(ExitToPlace());
        /*
        Future.delayed(Duration(milliseconds: 100)).then((value) =>
            _coreApiBloc.add(EnterToPlace(
                userID: widget.currentUser.userId!,
                enteredPlaceID: widget.enteredPlace.uid!)));*/
        break;
      case AppLifecycleState.paused:
        debugPrint('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        debugPrint('appLifeCycleState detached');
        break;
    }
  }

  late BottomNavBarBloc _bottomNavBarBloc;
  //late DatabaseBloc _databaseBloc;

  //final NotificationBloc _notificationBloc = getIt<NotificationBloc>();
  final SizeHelper sizeHelper = SizeHelper();
  ThemeHelper themeHelper = ThemeHelper();

  bool isConnected = true;

  //TODO user gelmeme durumunda sharedPref bak yoksa oturumdan çıkış yap tekrar girmesini iste
  //

  List<Artboard?> artboards = [null, null, null, null, null];
  List<SMIBool?> triggers = [null, null, null, null, null];

  int activeIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    /*_notificationBloc
        .add(GetNotifications(currentUserID: widget.gelenUser.userId!));
    _notificationBloc.add(SaveToken());
    controllerBloc = BlocProvider.of<ControllerBloc>(context);
    controllerBloc.add(ControllInternetConnection());*/
    //_databaseBloc = BlocProvider.of<DatabaseBloc>(context);
    //_databaseBloc.add(ControllAuthState());

    sharedUserKaydet("aaa");
    _bottomNavBarBloc = BottomNavBarBloc();

    super.initState();
  }

  int bottomNavBarIndex = 0;

  @override
  void dispose() {
    _bottomNavBarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _curvedKey = GlobalKey();

    return Scaffold(
      backgroundColor: Colors.black,
      //Safe areada ne gözükmesini istiyorsan onu yapmak gerekiyor
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!) {
              case NavBarItem.HOME:
                return const HomePage();
              case NavBarItem.FIND:
                return const FindPage();
              case NavBarItem.DISEAS:
                return const DiseasePage();
              /*case NavBarItem.PROFILE:
                return ProfilePage();*/
            }
          }
          return Container();
        },
      ),
      bottomNavigationBar: StreamBuilder(
          //blocdaki streami dinlemek
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          builder: (context, snapshot) {
            return AnimatedBottomNavigationBar.builder(
              backgroundColor: const Color(0XFF252F48),
              splashColor: themeHelper.primaryColor,
              activeIndex: bottomNavBarIndex,
              gapLocation: GapLocation.none,

              notchSmoothness: NotchSmoothness.softEdge,
              onTap: (index) => setState(() => {_bottomNavBarBloc.pickItem(index), bottomNavBarIndex = index}),
              itemCount: 3,
              tabBuilder: (int index, bool isActive) {
                final color = isActive ? themeHelper.primaryColor : Colors.white;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          iconList[index],
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AutoSizeText(
                        navbarString[index],
                        maxLines: 1,
                        style: GoogleFonts.lilitaOne(color: color),
                      ),
                    )
                  ],
                );
              },
              //other params
            );
          }),
    );
  }

  List<String> iconList = [
    "assets/icons/home.png",
    "assets/icons/search.png",
    "assets/icons/book.png",
    // "assets/icons/profile.png"
  ];

  List<String> navbarString = ["Home", "Find", "Guide"];

  Future<void> sharedUserKaydet(String userID) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.setString("userID", userID);
  }
}

/*class MyDelegateBuilder extends DelegateBuilder {
  final List<Artboard?> artboards;
  SizeHelper sizeHelper = SizeHelper();

  MyDelegateBuilder(this.artboards);
  @override
  Widget build(BuildContext context, int index, bool active) {
    return SizedBox(
      width: active ? sizeHelper.height! * 0.06 : sizeHelper.height! * 0.055,
      height: active ? sizeHelper.height! * 0.06 : sizeHelper.height! * 0.055,
      child: artboards[index] != null
          ? Rive(
              artboard: artboards[index]!,
            )
          : Container(),
    );
  }
}*/
