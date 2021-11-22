import 'package:flutter/material.dart';
import '../constants.dart';

class SettingButton extends StatelessWidget {
  SettingButton({this.icon, this.title, @required this.onPressed});
  final icon;
  final title;
  final onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5.0,
        color: kLightPrimaryThemeColor,
        borderRadius: BorderRadius.circular(10.0),
        child: FlatButton(
          onPressed: () {
            onPressed();
          },
          minWidth: double.infinity,
          height: 55.0,
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
