import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gossip_box/constants.dart';
import 'package:gossip_box/screens/reset_splash_screen.dart';
import 'login_screen.dart';
import '../helpers/user_existence.dart';
import 'package:lottie/lottie.dart';

String userName = '';


class ValidatorScreen extends StatefulWidget {

  ValidatorScreen({this.name}){
    userName = name;
  }
  final name;
  static const String id = "validator_screen";
  @override
  _ValidatorScreenState createState() => _ValidatorScreenState();
}

class _ValidatorScreenState extends State<ValidatorScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late Timer timer;
  late User user;
  @override
  void dispose()async
  {
    UserExistance tempUser = new UserExistance();
    await tempUser.checkExistance('${user.email}');
    if(tempUser.exist)
      {
        print('User Exists');
      }
    else if(user.emailVerified){
      user.updateDisplayName(userName.substring(0,1).toUpperCase() + userName.substring(1));
      _firestore.collection('users').doc(user.uid).set(
          {
            'email': user.email,
            'id': user.uid,
            'searchKey': user.email.toString()[0],
            'userName': userName.substring(0,1).toUpperCase() + userName.substring(1),
            'photoURL': 'https://github.com/NSVEGUR/College-CodeTrack/blob/main/user.png?raw=true',
          }
      );
    }
    if(!user.emailVerified)
      {
        user.delete();
      }
    timer.cancel();
    super.dispose();
  }
  @override
  void initState() {
    try {
      final tempUser = _auth.currentUser;
      if (tempUser != null) {
        user = tempUser;
        // print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
        checkMailVerified();
    });
    super.initState();
  }
  Future<void>checkMailVerified()async
  {
    user = _auth.currentUser!;
    await user.reload();
    if(user.emailVerified)
      {
         dispose();
         Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetSplashScreen(mail: user.email, reset: false,)));
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryThemeColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Lottie.asset('assets/waiting.json')),
            Text(
              'A Verification mail is sent to ${user.email}.\n ',
              style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 10,
                fontWeight: FontWeight.w900
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Text(
                'Please Verify',
                style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 13,
                    color: kSecondaryTextColor
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
