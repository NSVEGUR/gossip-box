import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';
import '../components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';
import 'validator_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:blobs/blobs.dart';

late User loggedInUser;

class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String userName = '';
  TextEditingController mailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController userNameTextController = TextEditingController();
  late FocusNode myFocusNode;
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    mailTextController.dispose();
    passwordTextController.dispose();
    userNameTextController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryThemeColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(
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
                  Flexible(child: Lottie.asset('assets/register.json')),
                  TextFormField(
                    focusNode: myFocusNode,
                    controller: mailTextController,
                    validator: (email) => !EmailValidator.validate('$email')
                        ? 'Invalid Email'
                        : null,
                    autofillHints: [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter new email',
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: userNameTextController,
                    validator: (name)=>(name.toString().length>10 || name.toString().length<3)?
                       'Username contains atleast 3 and atmost 10 characters'
                        :null,
                    onChanged: (value) {
                      userName = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        prefixIcon: Icon(Icons.account_box),
                        hintText: 'Enter new User name'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: passwordTextController,
                    obscureText: true,
                    validator: (pwd)=>(pwd.toString().length<6 || pwd.toString().length>12)?
                    'Password contains atleast 6 and atmost 12 characters'
                        :null,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Enter new password'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RoundedButton(
                    color: kDarkPrimaryThemeColor,
                    title: 'Register',
                    onPressed: () async {
                      final form = formKey.currentState!;
                      if (form.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        bool _notExist = true;
                        late UserCredential user;
                        try {
                          print('............trying..............');
                          user = (await _auth.createUserWithEmailAndPassword(
                              email: email, password: password));
                        } catch (signUpError) {
                          print('....printing sign up error..........');
                          print('...........${signUpError.toString()}..............');
                          print('...checking if block.............');
                          if(signUpError.toString() == '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
                            print('................running...........');
                            _notExist = false;
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
                                  fontSize: 25
                                ),
                                descStyle: TextStyle(fontFamily: 'NotoSans', color: kSecondaryTextColor, fontSize: 13),
                              ),
                              title: "Error!!",
                              desc: "Email already exists",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Try again",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                                  ),
                                  color: Colors.black,
                                  onPressed: () => Navigator.pop(context),
                                  width: 140,
                                )
                              ],
                            ).show();
                            mailTextController.clear();
                            passwordTextController.clear();
                            userNameTextController.clear();
                            email = '';
                            password = '';
                            userName = '';
                            myFocusNode.requestFocus();
                          }
                        }
                        if (_notExist) {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            mailTextController.clear();
                            passwordTextController.clear();
                            userNameTextController.clear();
                            email = '';
                            password = '';

                            if (user != null && _notExist) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ValidatorScreen(
                                    name: userName,
                                  ),
                                ),
                              );
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            print('.......second try block catch.......');
                            print(e);
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          )
          ],
        ),
      ),
    );
  }
}
