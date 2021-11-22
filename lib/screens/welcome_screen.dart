import 'package:flutter/material.dart';
import 'package:gossip_box/constants.dart';
import 'package:gossip_box/screens/login_screen.dart';
import 'package:gossip_box/screens/registration_screen.dart';
import 'package:lottie/lottie.dart';
import '../components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blobs/blobs.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  static const colorizeColors = [
    kDarkPrimaryThemeColor,
    kPrimaryThemeColor,
    kLightPrimaryThemeColor,
    Colors.black,
  ];
  static const colorizeTextStyle = TextStyle(
    fontSize: 35.0,
    fontFamily: 'NotoSans',
    fontWeight: FontWeight.w900,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryThemeColor,
      body: Stack(
          children: [
            Positioned(
              left: -90,
              bottom: -100,
              child: Blob.random(
                size: 300,
                styles: BlobStyles(
                  color: kBlobColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(child: Lottie.asset('assets/welcome.json')),
                Row(
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset('images/logo.png'),
                        height: 100,
                      ),
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Gossip Box',
                          textStyle: colorizeTextStyle,
                          colors: colorizeColors,
                        ),
                      ],
                      isRepeatingAnimation: true,
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 48.0,
                ),
                RoundedButton(
                  color: kSecondaryThemeColor,
                  title: 'Sign In',
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account!?",
                      style: TextStyle(
                        color: Color(0xFF6c757d),
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      },
                      child: const Text(
                        ' Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'NotoSans',
                          // decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    )
                  ],
                )
              ],
          ),
            ),
            Positioned(
              right: -90,
              top: -100,
              child: Blob.random(
                size: 300,
                styles: BlobStyles(
                  color: kBlobColor,
                ),
              ),
            ),
          ],

        ),
    );
  }
}
