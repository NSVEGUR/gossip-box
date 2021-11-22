import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import '../constants.dart';
import 'login_screen.dart';


class ResetSplashScreen extends StatefulWidget {
  ResetSplashScreen({this.mail, this.reset });
  final mail;
  final reset;
  @override
  _ResetSplashScreenState createState() => _ResetSplashScreenState(mail: mail, reset: reset);
}
class _ResetSplashScreenState extends State<ResetSplashScreen> {
  _ResetSplashScreenState({this.mail, this.reset});
  final mail;
  final reset;
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      backgroundColor: kPrimaryThemeColor,
      image: Image.asset('assets/confirmation.gif'),
      loaderColor: Colors.white,
      photoSize: 150,
      loadingText: Text(
        reset ? 'Password Reset mail is sent to $mail': '$mail is registered successfully',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'NotoSans',
          fontSize: 10,
            fontWeight: FontWeight.w900,
        ),
      ),
      navigateAfterSeconds: LoginScreen.id,
      useLoader: false,
    );
  }
}
