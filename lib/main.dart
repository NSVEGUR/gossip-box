// @dart=2.9
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import './screens/welcome_screen.dart';
import './screens/login_screen.dart';
import './screens/registration_screen.dart';
import 'constants.dart';
import './screens/gossip_screen.dart';
import './screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'screens/reset_screen.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(GossipBox());
}

class GossipBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: EntranceAnimationScreen.id,
      // initialRoute: EntranceAnimationScreen.id,
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: kDarkPrimaryThemeColor,
          secondary: kDarkPrimaryThemeColor,
        ),
      ),
      routes:{
        EntranceAnimationScreen.id: (context) => EntranceAnimationScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context)=>LoginScreen(),
        ResetScreen.id: (context)=>ResetScreen(),
        RegistrationScreen.id: (context)=> RegistrationScreen(),
        GossipScreen.id: (context)=>GossipScreen(),
      },
    );
  }
}
