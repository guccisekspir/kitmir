import 'package:flutter/material.dart';
import 'package:kitmir/helpers/sizeHelper.dart';
import 'package:kitmir/helpers/themeHelper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ThemeHelper themeHelper = ThemeHelper();
  SizeHelper sizeHelper = SizeHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eben();
  }

  eben() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        // Display current offering with offerings.current
        debugPrint(offerings.current!.identifier);
      } else {
        debugPrint("Null aga");
      }
    } on Exception catch (e) {
      debugPrint("hata aga" + e.toString());

      // optional error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeHelper.backgroundColor,
      height: sizeHelper.height,
      width: sizeHelper.width,
      child: Column(
        children: [],
      ),
    );
  }
}
