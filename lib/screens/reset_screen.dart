import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';
import '../components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:blobs/blobs.dart';
import 'reset_splash_screen.dart';

class ResetScreen extends StatefulWidget {
  static const String id = "reset_screen";
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  TextEditingController mailTextController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  late FocusNode myFocusNode;
  @override
  void dispose() {
    mailTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();
  }

  TextEditingController passwordTextController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryThemeColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(children: [
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'logo',
                          child: Container(
                            child: Image.asset('images/logo.png'),
                            height: 60,
                          ),
                        ),
                        Text(
                          'Gossip Box',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'NotoSans',
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(child: Lottie.asset('assets/reset.json')),
                  TextFormField(
                    focusNode: myFocusNode,
                    controller: mailTextController,
                    validator: (email) => !EmailValidator.validate('$email')
                        ? 'Enter a valid email'
                        : null,
                    autofillHints: [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  RoundedButton(
                    color: kDarkPrimaryThemeColor,
                    title: 'Reset',
                    onPressed: () async {
                      final form = formKey.currentState!;
                      if (form.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        await _auth
                            .sendPasswordResetEmail(email: email)
                            .then((value) {
                          setState(() {
                            showSpinner = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetSplashScreen(
                                        mail: email,
                                        reset: true,
                                      )));
                        }).catchError((e) {
                          if (e.toString() ==
                              '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
                            setState(() {
                              showSpinner = false;
                            });
                            Alert(
                              context: context,
                              image: Image.asset('assets/warning.png'),
                              style: const AlertStyle(
                                isCloseButton: false,
                                isOverlayTapDismiss: false,
                                animationType: AnimationType.fromTop,
                                titleStyle: TextStyle(
                                    fontFamily: 'NotoSans',
                                    fontWeight: FontWeight.w900,
                                    color: Colors.red,
                                    fontSize: 25),
                                descStyle: TextStyle(
                                    fontFamily: 'NotoSans',
                                    color: kSecondaryTextColor,
                                    fontSize: 13),
                              ),
                              title: "Error!!",
                              desc: "Email already exists",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Try again",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  color: Colors.black,
                                  onPressed: () => Navigator.pop(context),
                                  width: 140,
                                )
                              ],
                            ).show();
                            mailTextController.clear();
                            email = '';
                            myFocusNode.requestFocus();
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
