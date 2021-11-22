import 'package:flutter/material.dart';
import 'package:gossip_box/screens/reset_screen.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';
import '../components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'gossip_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:blobs/blobs.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  Flexible(child: Lottie.asset('assets/login.json')),
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
                  TextFormField(
                    controller: passwordTextController,
                    obscureText: true,
                    validator: (pwd) => pwd.toString().length == 0
                        ? 'Password cannot be empty'
                        : null,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Enter your password',
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  RoundedButton(
                    color: kDarkPrimaryThemeColor,
                    title: 'Log In',
                    onPressed: () async {
                      final form = formKey.currentState!;
                      if (form.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        late UserCredential user;
                        bool correct = true;
                        try {
                          user = (await _auth.signInWithEmailAndPassword(
                              email: email, password: password));
                        } catch (signInError) {
                          print(
                              '........${signInError.toString()}............');
                          if (signInError.toString() ==
                              '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.' ||
                              signInError.toString() ==
                                  '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
                            setState(() {
                              showSpinner = false;
                            });
                            correct = false;
                            Alert(
                              context: context,
                              image: Image.asset('assets/warning.png'),
                              style: const AlertStyle(
                                backgroundColor: kPrimaryThemeColor,
                                isCloseButton: false,
                                isOverlayTapDismiss: false,
                                animationType: AnimationType.fromTop,
                                titleStyle: TextStyle(
                                  fontFamily: 'NotoSans',
                                  fontWeight: FontWeight.w900,
                                  color: Colors.red,
                                  fontSize: 25,
                                ),
                                descStyle: TextStyle(
                                    fontFamily: 'NotoSans',
                                    color: kSecondaryTextColor,
                                    fontSize: 13),
                              ),
                              title: "Error!!",
                              desc: "Email or Password is INCORRECT",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Try again",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  width: 140,
                                  color: Colors.black,
                                )
                              ],
                            ).show();
                            mailTextController.clear();
                            passwordTextController.clear();
                            email = '';
                            password = '';
                            myFocusNode.requestFocus();
                          }
                        }
                        if (correct) {
                          email = mailTextController.text;
                          try {
                            user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (user != null) {
                              passwordTextController.clear();
                              mailTextController.clear();
                              password = '';
                              email = '';
                              Navigator.pushNamed(context, GossipScreen.id);
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            print(e);
                          }
                        }
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Forgot Password!?",
                        style: TextStyle(
                          color: Color(0xFF6c757d),
                          fontFamily: 'NotoSans',
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ResetScreen.id);
                        },
                        child: const Text(
                          ' Reset',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'NotoSans',
                            // decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      )
                    ],
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
