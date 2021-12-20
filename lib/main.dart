import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitmir/landPage.dart';
import 'package:kitmir/locator.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/databaseBloc/bloc/database_bloc.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await Purchases.setDebugLogsEnabled(true);
  await Purchases.setup("appl_CJNXrsvVmCaaknnJYWWbcABXlHR");

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirst = false;
  if (prefs.getBool("isFirst") == null) {
    debugPrint("isfirst" + prefs.getBool("isFirst").toString());
    isFirst = true;

    debugPrint("isfirst" + prefs.getBool("isFirst").toString());
  }
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('tr'), Locale('es')],
        useOnlyLangCode: true,
        path: 'assets/translations', // <-- change the path of the translation files
        child: App(
          isFirst: isFirst,
        )),
  );
}

class App extends StatelessWidget {
  final bool isFirst;
  const App({Key? key, required this.isFirst}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseAnalytics analytics = FirebaseAnalytics();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*  navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],*/

      title: 'Kıtmir',
      localizationsDelegates: context.localizationDelegates,
      // <-- add this
      supportedLocales: context.supportedLocales,
      // <-- add this
      locale: context.locale,
      theme: ThemeData(
        textTheme: TextTheme(
            subtitle2: GoogleFonts.roboto(color: Colors.white), bodyText2: GoogleFonts.roboto(color: Colors.white))
          ..apply(bodyColor: Colors.white, displayColor: Colors.white),
        hintColor: Colors.white,
        hoverColor: Colors.white,
        primarySwatch: Colors.green,
        primaryColor: const Color(0XFF00C02C),
        scaffoldBackgroundColor: const Color(0XFFEEEEEE),
        errorColor: Colors.redAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => DatabaseBloc(),
        child: LandPage(
          isFirst: isFirst,
        ),
      ),

      builder: EasyLoading.init(),
    );
  }
}
