import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gossip_box/components/setting_buttons.dart';
import 'package:gossip_box/components/user_mail_button.dart';
import 'package:gossip_box/helpers/manage_friend_requests.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/user_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'add_friends_screen.dart';
import 'chat_screen.dart';
import 'friend_requests_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blobs/blobs.dart' as blobMaker;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' as io;
import '../helpers/update_profile_socially.dart';
import '../helpers/about_creater.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
bool showSpinner = true;
late BuildContext primaryBuildContext;
bool readyUsers = false;

class GossipScreen extends StatefulWidget {
  static const String id = "gossip_screen";
  @override
  _GossipScreenState createState() => _GossipScreenState();
}

class _GossipScreenState extends State<GossipScreen> {
  final _auth = FirebaseAuth.instance;
  io.File? _image;
  bool imagePicked = false;
  String url = '';
  String photoURL = '';
  bool _notExist = false;
  late QuerySnapshot snapshot;
  bool close() {
    SystemNavigator.pop();
    return true;
  }

  Future getImageFromFirestore() async {
    snapshot = await _firestore.collection('users').get();
    readyUsers = true;
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("profilePics/${loggedInUser.email}");
    photoURL = await ref.getDownloadURL();
    print('photoURL of current user $photoURL');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getImageFromFirestore();
    friendsExists();
    saveSignIn();
    Requests request = Requests();
    request.deleteNoNeedRequests();
    // obtain shared preferences
  }

  Future friendsExists() async {
    // print('mesage?.............................');
    _notExist = false;
    await _firestore
        .collection('users')
        .doc(loggedInUser.uid)
        .collection('friends')
        .get()
        .then((data) => {
      if (data.docs.isEmpty)
        setState(() {
          _notExist = true;
        })
    });
    // print('show spinner set to false.............................');
    setState(() {
      // print('show spinner set to false.............................');
      showSpinner = false;
    });
  }

  ///////////////////////////////////////////////////////////////////////////////
  String userImage({userName}) => userName.toString()[0].toLowerCase();

  Widget buildProfileScreen(
      {required User loggedInUser,
      required BuildContext buildContext,
      required BuildContext primaryBuildContext}) {
    final _auth = FirebaseAuth.instance;

    saveSignOut() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('signedIn', false);
    }

    signOut() {
      saveSignOut();
      _auth.signOut();
      SystemNavigator.pop();
    }

    Widget initialiseAddFriends(secondaryBuildContext) => addFriendsScreen(
          buildContext: secondaryBuildContext,
        );
    Widget initialiseAcceptFriends(secondaryBuildContext) =>
        friendRequestsScreen(buildContext: secondaryBuildContext);

    Future uploadImageToFirebase() async {
      final FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("profilePics/${loggedInUser.email}");
      UploadTask uploadTask = ref.putFile(_image!);
      uploadTask.then((p0) async {
        print(p0);
        url = await ref.getDownloadURL();
        setState(() {
          photoURL = url;
        });
        print(url);
        loggedInUser.updatePhotoURL(url);
        print('updating in profile in me....................');
        await _firestore
            .collection('users')
            .doc(loggedInUser.uid)
            .update({'photoURL': url}).then((value) => print('updated in me $url')).catchError((onError)=>print('error in updating photo in me $onError'));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Uploaded'),
            )
        );
        UpdateProfile profile = UpdateProfile();
        await profile.updateProfileSocially(loggedInUser, url);
      });

    }

    Future getImageFromUser() async {
      try {
        final ImagePicker _picker = ImagePicker();
        var image = await _picker.pickImage(source: ImageSource.gallery);
        if (image == null) return;
        final tempImage = io.File(image.path);
        setState(() {
          _image = tempImage;
          imagePicked = true;
          print('image path: $_image');
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Uploading........'),
              )
          );
          Navigator.pop(primaryBuildContext);
          uploadImageToFirebase();
        });
      } on PlatformException catch (e) {
        print('Failed to Pick Image $e');
      }
    }

    Widget imageProfile() {
      return GestureDetector(
        onTap: () async {
          getImageFromUser();
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                ClipOval(
                  child: photoURL != ''
                      ? Image.network('$photoURL',
                          height: 100, width: 100, fit: BoxFit.cover)
                      : Image.asset('images/user.png', height: 100, width: 100),
                ),
                Positioned(
                  bottom: 10,
                  child: ClipOval(
                    child: Material(
                      color: kBlobColor,
                      child: InkWell(
                        splashColor: kPrimaryThemeColor,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: Icon(Icons.camera_alt),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    var _list = [
      imageProfile(),
      UserMailButton(
        icon: Icons.account_circle,
        title: loggedInUser.displayName,
        subtitle: 'user name',
        isBiggerFont: true,
      ),
      UserMailButton(
        icon: Icons.mail,
        title: loggedInUser.email,
        subtitle: 'user mail ID',
        isBiggerFont: false,
      ),
      SettingButton(
          icon: Icons.person_add,
          title: 'Add Friends',
          onPressed: () {
            Navigator.of(buildContext).pop();
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              context: buildContext,
              builder: (context) => initialiseAddFriends(context),
            );
          }),
      SettingButton(
          icon: Icons.pending,
          title: 'Friend Requests',
          onPressed: () {
            Navigator.of(buildContext).pop();
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              context: buildContext,
              builder: (context) => initialiseAcceptFriends(buildContext),
            );
          }),
      SettingButton(
          icon: Icons.logout,
          title: 'SignOut',
          onPressed: () {
            // _auth.signOut();
            // Navigator.pop(buildContext);
            // Navigator.pop(primaryBuildContext);
            Alert(
              context: primaryBuildContext,
              image: Image.asset('assets/logout.png'),
              style: const AlertStyle(
                backgroundColor: kPrimaryThemeColor,
                animationType: AnimationType.fromTop,
                titleStyle: TextStyle(
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w900,
                ),
                descStyle: TextStyle(fontFamily: 'NotoSans'),
              ),
              title: "SIGN OUT",
              desc: "Are you sure!?",
              buttons: [
                DialogButton(
                  child: Text(
                    "YES",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => {signOut()},
                  color: Colors.black,
                ),
                DialogButton(
                  child: Text(
                    "NO",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  onPressed: () => {Navigator.pop(primaryBuildContext)},
                  color: kLightPrimaryThemeColor,
                )
              ],
            ).show();
          }),
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.69,
      maxChildSize: 0.79,
      builder: (BuildContext context, ScrollController scrollController) =>
          Container(
        constraints: BoxConstraints.expand(),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: kPrimaryThemeColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25)),
          // image: DecorationImage(
          //   image: AssetImage('assets/chatBackground.png'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Stack(children: [
          Positioned(
            left: -90,
            bottom: -100,
            child: blobMaker.Blob.random(
              size: 300,
              styles: blobMaker.BlobStyles(
                color: kBlobColor,
              ),
            ),
          ),
          Positioned(
            right: -90,
            top: -100,
            child: blobMaker.Blob.random(
              size: 300,
              styles: blobMaker.BlobStyles(
                color: kBlobColor,
              ),
            ),
          ),
          ListView(
            controller: scrollController,
            children: _list,
          ),
        ]),
      ),
    );
  }
  ///////////////////////////////////////////////////////////////////////////////

  saveSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('signedIn', true);
    prefs.setString('signedInMail', '${loggedInUser.email}');
    print('..........signIn saved: ${prefs.getBool('signedIn')}');
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  void buildBottomSheet(workToBeDone) {
    Widget makeDismissable({required Widget child}) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: GestureDetector(onTap: () {}, child: child),
        );

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (context) => makeDismissable(child: workToBeDone()));
  }

  Widget initialiseProfile() => buildProfileScreen(
      loggedInUser: loggedInUser,
      buildContext: context,
      primaryBuildContext: primaryBuildContext);
  Widget initialiseAddFriends(secondaryBuildContext) => addFriendsScreen(
        buildContext: secondaryBuildContext,
      );

  @override
  Widget build(BuildContext context) {
    primaryBuildContext = context;
    return WillPopScope(
      onWillPop: () async {
        return close();
      },
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: RefreshWidget(
          onRefresh: friendsExists,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: kDarkPrimaryThemeColor,
              appBar: AppBar(
                // leading: GestureDetector(
                //   onTap: (){
                //     print('tapping........');
                //     showAboutCreator(context);
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 8, top: 8),
                //     child: ClipOval(
                //       child: Image.asset(
                //         'images/logo.png',
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // ),
                automaticallyImplyLeading: false,
                elevation: 0,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.segment),
                        onPressed: () {
                          buildBottomSheet(initialiseProfile);
                        }),
                  ),
                ],
                title: GestureDetector(
                  onTap: (){
                    showAboutCreator(context);
                  },
                  child: const Text(
                    'Gossip Box',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NotoSans',
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                toolbarHeight: 60,
                backgroundColor: kDarkPrimaryThemeColor,
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.black,
                elevation: 10,
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    context: context,
                    builder: (context) => initialiseAddFriends(context),
                  );
                },
                child: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
              ),
              body: SafeArea(
                child: Container(
                    constraints: BoxConstraints.expand(),
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: const BoxDecoration(
                      color: kPrimaryThemeColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25)),
                      // image: DecorationImage(
                      //   image: AssetImage('assets/chatBackground.png'),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: Stack(children: [
                      Positioned(
                        left: -90,
                        bottom: -100,
                        child: blobMaker.Blob.random(
                          size: 300,
                          styles: blobMaker.BlobStyles(
                            color: kBlobColor,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -90,
                        top: -100,
                        child: blobMaker.Blob.random(
                          size: 300,
                          styles: blobMaker.BlobStyles(
                            color: kBlobColor,
                          ),
                        ),
                      ),
                      _notExist
                          ?  Column(
                        children: [
                          Lottie.asset('assets/addFriends.json'),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('You have got no Friends Please add......',
                              style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontSize: 15,
                                color: kDarkPrimaryThemeColor,
                              ),),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: (){
                              print('tapping.........');
                              friendsExists();
                            },
                            child: Text('Tap on me to Refresh',
                                style: TextStyle(
                                  fontFamily: 'NotoSans',
                                  fontSize: 13,
                                  color: kDarkPrimaryThemeColor,
                                  fontWeight: FontWeight.bold,
                                ),),
                          ),
                        ],
                      )
                          :FriendsStream(),
                    ]),
                  ),
              )),
        ),
      ),
    );
  }
}

class FriendsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: _firestore
            .collection('users')
            .doc(loggedInUser.uid)
            .collection('friends')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              print(loggedInUser.displayName);
              // print('............calling user button......photo URL ${data['photoURL']}');
              return UserButton(
                userName: data['userName'],
                email: data['email'],
                photoURL: data['photoURL'],
                unread: data['unread'],
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        transitionsBuilder:
                            (context, animation, animationTime, child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.decelerate);
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;
                          final tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          final offsetAnimation = animation.drive(tween);
                          return ScaleTransition(
                            alignment: Alignment.center,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, animationTime) {
                          return ChatScreen(
                              friendMail: data['email'],
                              friendUserName: data['userName'],
                              photoURL: data['photoURL'],
                          );
                        },
                      ));
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}



class RefreshWidget extends StatefulWidget {
  final Future Function() onRefresh;
  final Widget child;
  const RefreshWidget({Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) => buildAgain();
  Widget buildAgain() => RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: widget.child
  );
}
