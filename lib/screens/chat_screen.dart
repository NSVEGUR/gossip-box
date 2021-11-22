import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/find_friend.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:blobs/blobs.dart' as blobMaker;
import '../helpers/show_about.dart';
import '../helpers/update_unread.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

bool showSpinner = true;
// bool hiMessage = true;

class ChatScreen extends StatefulWidget {
  final String friendMail, friendUserName, photoURL;
  ChatScreen({required this.friendMail, required this.friendUserName, required this.photoURL}) {
    initializeDateFormatting('ta_IN', null);
    // print('building chat screen');
  }
  static const String id = "chat_screen";
  @override
  _ChatScreenState createState() =>
      _ChatScreenState(friendMail: friendMail, friendUserName: friendUserName, photoURL: photoURL);
}

class _ChatScreenState extends State<ChatScreen> {
  final String friendMail, friendUserName, photoURL;

  _ChatScreenState({required this.friendMail, required this.friendUserName, required this.photoURL});

  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String textMessage = '';
  bool dismiss = false;
  String friendID = '';
  bool _notExist = false;
  UpdateUnread update = UpdateUnread();
  int unread = 0;

  @override
  void initState() {
    // TODO: implement initState
    // print('....init of chatscreen');
    getFriendDetails();
    super.initState();
    getCurrentUser();
    getUnreadAndMakeReadAll();
    messagesExists();
  }

  getFriendDetails() async {
    FindFriend friend = new FindFriend();
    friendID = await friend.findFriendID(friendMail);
    print('friend id:  .................$friendID');
    setState(() {
      showSpinner = false;
    });
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

  messagesExists() async {
    // print('mesage?.............................');
    final snapshots = await _firestore
        .collection('users')
        .doc(loggedInUser.uid)
        .collection('friends')
        .doc(friendMail)
        .collection('messages')
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

  getUnreadAndMakeReadAll()async{
    update.removeUnreadInMe(loggedInUser: loggedInUser, friendMail: friendMail);
    unread = await update.getUnreadInFriend(friendMail: friendMail, myMail: '${loggedInUser.email}');
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: kDarkPrimaryThemeColor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap:()
              {
                showDailogFunc(context, photoURL, friendUserName, friendMail);
              },
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: ClipOval(
                child: photoURL != ''
                    ? Image.network('$photoURL', fit: BoxFit.cover): Image.asset(
                  'images/user.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: Text(
            friendUserName,
            style: TextStyle(
              textBaseline: TextBaseline.alphabetic,
              color: Colors.white,
              fontFamily: 'NotoSans',
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          backgroundColor: kDarkPrimaryThemeColor,
        ),
        body: SafeArea(
            child: Container(
          constraints: BoxConstraints.expand(),
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            color: kPrimaryThemeColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25)),
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
              // Lottie.asset('assets/watch.json'),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _notExist
                      ?  Column(
                        children: [
                          Lottie.asset('assets/chat.json', height: 130),
                          Text('Start Gossiping with $friendUserName.....',
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 13,
                              color: kDarkPrimaryThemeColor,
                            ),)
                        ],
                      )
          : MessagesStream(
                          friendMail: friendMail,
                        ),
                  // MessagesStream(),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8, left: 8),
                            child: TextField(
                              style: TextStyle(
                                fontFamily: 'NotoSans',
                                color: Colors.black,
                              ),
                              controller: messageTextController,
                              cursorColor: kSecondaryTextColor,
                              onChanged: (value) {
                                textMessage = value;
                              },
                              decoration: kMessageTextFieldDecoration,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              messageTextController.clear();
                              final DateTime date = DateTime.now();
                              _firestore
                                  .collection('users')
                                  .doc(loggedInUser.uid)
                                  .collection('friends')
                                  .doc(friendMail)
                                  .collection('messages')
                                  .add({
                                'message': textMessage,
                                'sender': loggedInUser.email,
                                'time': date.millisecondsSinceEpoch,
                              });
                              _firestore
                                  .collection('users')
                                  .doc(friendID)
                                  .collection('friends')
                                  .doc(loggedInUser.email)
                                  .collection('messages')
                                  .add({
                                'message': textMessage,
                                'sender': loggedInUser.email,
                                'time': date.millisecondsSinceEpoch,
                              });
                              unread+=1;
                              update.updateUnreadInFriend(friendMail: friendMail, myMail:'${loggedInUser.email}', numberOfUnread: unread);
                              setState(() {
                                _notExist = false;
                              });
                            },
                            child: Icon(Icons.send, color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final friendMail;
  MessagesStream({required this.friendMail}) {
    // print('friend mail in message stream: ................$friendMail');
  }
  @override
  Widget build(BuildContext context) {
    return !showSpinner
        ? StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('users')
                .doc(loggedInUser.uid)
                .collection('friends')
                .doc(friendMail)
                .collection('messages')
                .orderBy('time')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              return Expanded(
                child: ListView(
                  reverse: true,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  children: snapshot.data!.docs.reversed
                      .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    // print(data);
                    final messageText = data['message'];
                    final messageSender = data['sender'];
                    final messageTime = data['time'];
                    final currentUser = loggedInUser.email;
                    final messageWidget = MessageBubble(
                      messageText: messageText,
                      messageTime: messageTime,
                      isMe: currentUser == messageSender,
                    );
                    return messageWidget;
                  }).toList(),
                ),
              );
            },
          )
        : Container();
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    @required this.messageText,
    @required this.messageTime,
    @required this.isMe,
  }) {
    time = DateTime.fromMillisecondsSinceEpoch(messageTime);
    time = DateFormat('hh:mm a').format(time);
  }
  final messageText;
  final messageTime;
  final isMe;
  var time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            elevation: 10,
            color: isMe ? kDarkPrimaryThemeColor : kLightPrimaryThemeColor,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(messageText,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'NotoSans',
                    color: isMe ? Colors.white : Colors.black,
                  )),
            ),
          ),
          Text(
            time.toString(),
            style: TextStyle(
              fontSize: 10,
              color: kSecondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
