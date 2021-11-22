import 'package:flutter/material.dart';
import 'package:gossip_box/constants.dart';

class UserMailButton extends StatelessWidget {
  UserMailButton(
      {this.icon, this.title, this.subtitle, this.isBiggerFont});
  final icon;
  final title;
  final subtitle;
  final isBiggerFont;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: isBiggerFont ? 20: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 12,
                        color: kSecondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
