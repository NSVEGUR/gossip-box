import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:gossip_box/helpers/manage_friend_requests.dart';
import '../constants.dart';
import '../helpers/search_service.dart';
import '../components/friend_button.dart';
import '../helpers/find_friend.dart';
import 'package:blobs/blobs.dart' as blobMaker;

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
late BuildContext buildContext;
late BuildContext secondaryContext;
List<Widget> users = [];
List<Widget> searchedUsers = [];


class addFriendsScreen extends StatefulWidget {
  addFriendsScreen({required this.buildContext}) {
    secondaryContext = buildContext;
  }
  // final primaryBuildContext;
  final buildContext;
  @override
  _addFriendsScreenState createState() => _addFriendsScreenState();
}

class _addFriendsScreenState extends State<addFriendsScreen> {
  final _auth = FirebaseAuth.instance;
  var queryResult = [];
  var searchStore = [];
  bool result = false;
  FindFriend friend = FindFriend();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    setState(() {
      printUsers();
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
    await _firestore.collection('users').get().then((data)async{
      for(int i = 0; i< data.docs.length; i++)
        {
          if((data.docs[i].data()['email'] != loggedInUser.email) && (!await friend.checkExistance(data.docs[i].data()['email'], loggedInUser.uid)))
            {
              setState(() {
                users.add(FriendButton(
                  userName: data.docs[i].data()['userName'],
                  email: data.docs[i].data()['email'],
                  state: true,
                  add: (){
                    // print('${data.docs[i].data()['email']} is added');
                    // print('$email is added');
                    Requests request = Requests();
                    request.addRequest(data.docs[i].data()['email']);
                  },
                  remove: (){
                    // print('${data.docs[i].data()['email']} is removed');
                    // print('$email is removed');
                    Requests request = Requests();
                    request.deleteRequest(data.docs[i].data()['email']);
                  },
                  accept: (){

                  },
                  reject: (){

                  },
                ));
              });
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
  void initiateSearch(String value) {
    if (value.length == 0) {
      setState(() {
        queryResult = [];
        searchStore = [];
        searchedUsers = [];
        printUsers();
        result = false;
      });
    } else {
      var covertedValue = value.toLowerCase();
      if (queryResult.length == 0 && value.length == 1) {
        SearchService().searchByName(value).then((QuerySnapshot data) {
          for (int i = 0; i < data.docs.length; i++) {
            queryResult.add(data.docs[i].data());
            searchStore = [];
            for (var element in queryResult) {
              if (element['email'].startsWith(covertedValue) &&
                  element['email'] != loggedInUser.email) {
                setState(() {
                  searchStore.add(element);
                  // print('Search Store $element');
                });
              }
            }
            searchStack();
            setState(() {
              result = true;
            });
            // print('Query Result ${data.docs[i].data()}');
          }
        });
      } else {
        searchStore = [];
        for (var element in queryResult) {
          if (element['email'].startsWith(covertedValue) &&
              element['email'] != loggedInUser.email) {
            setState(() {
              searchStore.add(element);
              // print('Search Store $element');
            });
          }
        }
        searchStack();
        setState(() {
          result = true;
        });
      }
    }
  }
  Widget buildFriendsStream(data) {
    return FriendButton(
      userName: data['userName'],
      email: data['email'],
      state: true,
      add: (){
        Requests request = Requests();
        request.addRequest(data['email']);
      },
      remove: (){
        Requests request = Requests();
        request.deleteRequest(data['email']);
      },
      accept: (){

      },
      reject: ()
      {

      },
    );
  }
  List<Widget> searchStack(){
    searchedUsers = [];
    print('made this zero');
    searchStore.forEach((element) async {
      print(element);
      print(searchStore.length);
      print('deleting existing friends');
      if(!await friend.checkExistance(element['email'], loggedInUser.uid))
        {
          print('adding to list');
          setState(() {
            searchedUsers.add(buildFriendsStream(element));
          });
        }
    });
    return searchedUsers;
  }
  @override
  Widget build(BuildContext context) {
    return makeDismissable(
      child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.6,
          maxChildSize: 0.9,
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
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: kSearchTextFieldDecoration,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.black,
                            onChanged: (value) {
                              initiateSearch(value);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            'Scroll for Suggestions',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'NotoSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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
                                      child: ListView(
                                          controller: scrollController,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          children: !result? users : searchedUsers,
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



