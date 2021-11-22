import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:gossip_box/helpers/manage_friend_requests.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';
import '../helpers/find_friend.dart';
import '../components/friend_button.dart';
import 'package:blobs/blobs.dart' as blobMaker;

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
late BuildContext buildContext;
late BuildContext secondaryContext;
List<Widget> users = [];
late Function refresh;

class friendRequestsScreen extends StatefulWidget {
  friendRequestsScreen({required this.buildContext}) {
    secondaryContext = buildContext;
  }
  // final primaryBuildContext;
  final buildContext;
  @override
  _friendRequestsScreenState createState() => _friendRequestsScreenState();
}

class _friendRequestsScreenState extends State<friendRequestsScreen> {
  final _auth = FirebaseAuth.instance;
  var queryResult = [];
  var searchStore = [];
  bool result = false;
  Requests request = Requests();
  FindFriend friend = FindFriend();
  bool _exist = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    printUsers();
    requestsExists();
  }


  requestsExists()async {
    final snapshots = await _firestore.collection('users').doc(loggedInUser.uid).collection('requests').get().then((data) => {
      if(data.docs.isEmpty)
        setState(() {
          _exist = false;
        })
    });
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
  }
  printUsers() async {
    setState(() {
      users = [];
    });
    await _firestore.collection('users').doc(loggedInUser.uid).collection('requests').get().then((data)=>{
      for(int i = 0; i< data.docs.length; i++)
        {
          if(data.docs[i].data()['email'] != loggedInUser.email)
            {
              users.add(FriendButton(
                userName: data.docs[i].data()['userName'],
                email: data.docs[i].data()['email'],
                state: false,
                add: (){
                  // print('${data.docs[i].data()['email']} is added');
                  // request.addRequest(data.docs[i].data()['email']);
                },
                remove: (){
                  // print('${data.docs[i].data()['email']} is removed');
                  // request.deleteRequest(data.docs[i].data()['email']);
                },
                accept: (){
                  Requests request = Requests();
                  request.acceptRequest(data.docs[i].data()['email'], data.docs[i].data()['userName']);
                },
                reject: (){
                  Requests request = Requests();
                  request.rejectRequest(data.docs[i].data()['email'], data.docs[i].data()['userName']);

                },
              ),
              )
            }
        }
    });
    setState(() {
    });
  }
  Widget makeDismissable({required Widget child}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.pop(secondaryContext),
    child: GestureDetector(onTap: () {}, child: child),
  );
  @override
  Widget build(BuildContext context) {
    return makeDismissable(
      child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.6,
          maxChildSize: 0.7,
          builder: (BuildContext context, ScrollController scrollController) =>
              Container(
                constraints: BoxConstraints.expand(),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: kPrimaryThemeColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25)),
                  // image: DecorationImage(
                  //   image: AssetImage('assets/chatBackground.png'),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: Stack(
                  children: [
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            'Requests',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'NotoSans',
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: _exist ? ListView(
                                  controller: scrollController,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  children: users
                                ): Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Lottie.asset('assets/watch.json', height: 50),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                          'You have no requests',
                                          style: TextStyle(
                                              color: kSecondaryTextColor,
                                              fontSize: 20,
                                              fontFamily: 'NotoSans'
                                          )
                                      ),
                                    ],
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )],
                ),
              )),
    );
  }
}



