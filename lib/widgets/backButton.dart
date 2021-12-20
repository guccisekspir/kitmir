import 'package:flutter/material.dart';
import 'package:kitmir/helpers/themeHelper.dart';

class BackButton extends StatelessWidget {
  final Color color;
  const BackButton({Key? key, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back, size: 20, color: color));
  }
}
