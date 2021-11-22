import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import '../constants.dart';
import 'welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gossip_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class EntranceAnimationScreen extends StatefulWidget {
  static const String id = "entrance_animation_screen";
  @override
  _EntranceAnimationScreenState createState() => _EntranceAnimationScreenState();
}

class _EntranceAnimationScreenState extends State<EntranceAnimationScreen> {
  bool signInAutomatically = false;
  String mail = '';
  @override
  void initState()
  {
    print('............calling auto sign in.........');
    super.initState();
    autoSignIn();
  }


  autoSignIn()async
  {
    print('.......initialising firebase app.........');
    await Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    final prefs = await SharedPreferences.getInstance();
    signInAutomatically = prefs.getBool('signedIn') ?? false;
    mail = prefs.getString('signedInMail') ?? '';
    print('................................signInAutoMatically: $signInAutomatically...................');
  }
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 3,
        backgroundColor: kPrimaryThemeColor,
        image: Image.asset('assets/splashLogo.gif'),
        loaderColor: Colors.white,
        photoSize: 160,
        loadingText: Text(
            'by NSVEGUR',
             style: TextStyle(
               color: Colors.black,
               fontFamily: 'NotoSans',
               fontSize: 20,
             ),
        ),
        navigateAfterSeconds: signInAutomatically? GossipScreen():WelcomeScreen(),
        useLoader: false,
      );
  }
}
