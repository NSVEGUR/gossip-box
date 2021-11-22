import 'package:cloud_firestore/cloud_firestore.dart';
import 'find_friend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'find_friend.dart';

class Requests {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _exist = false;
  String _friendID = '';
  String _photoURL = '';
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  Requests() {
    getCurrentUser();
    print('......got current user: ${loggedInUser.email}............');
    deleteNoNeedRequests();
  }

  //for current user
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

  //to delete no need requests
  deleteNoNeedRequests() async {
    FindFriend friend = FindFriend();
    print('..........deleting no need requests...........');
    await _firestore
        .collection('users')
        .doc(loggedInUser.uid)
        .collection('requests')
        .get()
        .then((data) async {
      for (int i = 0; i < data.docs.length; i++) {
        print(
            '.....${data.docs[i].data()['email']} checking if friend to me...');
        if (await friend.checkExistance(
            data.docs[i].data()['email'], loggedInUser.uid)) {
          await _firestore
              .collection('users')
              .doc(loggedInUser.uid)
              .collection('requests')
              .doc(data.docs[i].data()['email'])
              .delete()
              .then((value) => print('deleted succefully'))
              .catchError((e) => print(e));
          print('....delete frnd ${data.docs[i].data()['email']}......');
        }
      }
    });
  }

  //private functions
  _requestExist(String friendUid) async {
    print('.....checking if the request exist..........');
    await _firestore
        .collection('users')
        .doc(friendUid)
        .collection('requests')
        .get()
        .then((data) => {
              for (int i = 0; i < data.docs.length; i++)
                {
                  // print(data.docs[i].data())
                  if (loggedInUser.email.toString() ==
                      data.docs[i].data()['email'])
                    _exist = true
                }
            })
        .catchError((e) => print(e));
  }

  //request managers
  addRequest(String friendMail) async {
    print('....adding freind request to ${friendMail},,,,');
    FindFriend friend = new FindFriend();
    print('..........frinding friend id...');
    _friendID = await friend.findFriendID(friendMail);
    print('......friend id: ${_friendID}....');
    await _requestExist(_friendID);
    if (_exist) {
      print('Friend request by ${loggedInUser.email} exists in ${friendMail}');
    } else {
      await _firestore
          .collection('users')
          .doc(_friendID)
          .collection('requests')
          .doc(loggedInUser.email)
          .set({
        'email': loggedInUser.email,
        'userName': loggedInUser.displayName,
      });
      print('added friend request by ${loggedInUser.email} to ${friendMail}');
    }
  }

  deleteRequest(String friendMail) async {
    FindFriend friend = new FindFriend();
    _friendID = await friend.findFriendID(friendMail);
    await _requestExist(_friendID);
    if (_exist) {
      await _firestore
          .collection('users')
          .doc(_friendID)
          .collection('requests')
          .doc(loggedInUser.email)
          .delete()
          .then((value) => print('deleted succefully'))
          .catchError((e) => print(e));
      print('deleted friend request by ${loggedInUser.email} to ${friendMail}');
    }
  }

  //accept managers
  acceptRequest(String friendMail, String friendUserName) async {
    await _firestore
        .collection('users')
        .doc(loggedInUser.uid)
        .collection('requests')
        .doc(friendMail)
        .delete()
        .then((value) => print('accepted succefully'))
        .catchError((e) => print(e));
    FindFriend friend = new FindFriend();
    _friendID =  await friend.findFriendID(friendMail);
    _photoURL = await friend.findFriendPhotoURL(friendMail);
    if (!await friend.checkExistance(friendMail, loggedInUser.uid)) {
      await _firestore
          .collection('users')
          .doc(loggedInUser.uid)
          .collection('friends')
          .doc(friendMail)
          .set({
        'email': friendMail,
        'userName': friendUserName,
        'photoURL': _photoURL,
        'unread': 0,
      });
      await _firestore
          .collection('users')
          .doc(_friendID)
          .collection('friends')
          .doc(loggedInUser.email)
          .set({
        'email': loggedInUser.email,
        'userName': loggedInUser.displayName,
        'photoURL': loggedInUser.photoURL,
        'unread': 0,
      });
    }
  }

  rejectRequest(String friendMail, String friendUserName) async {
    await _firestore
        .collection('users')
        .doc(loggedInUser.uid)
        .collection('requests')
        .doc(friendMail)
        .set({
      'email': friendMail,
      'userName': friendUserName,
    });
    FindFriend friend = new FindFriend();
    if (await friend.checkExistance(friendMail, loggedInUser.uid)) {
      await _firestore
          .collection('users')
          .doc(loggedInUser.uid)
          .collection('friends')
          .doc(friendMail)
          .delete()
          .then((value) => print('deleted friend in me succefully'))
          .catchError((e) => print(e));
      _friendID = await friend.findFriendID(friendMail);
      await _firestore
          .collection('users')
          .doc(_friendID)
          .collection('friends')
          .doc(loggedInUser.email)
          .delete()
          .then((value) => print('deleted me in friend succefully'))
          .catchError((e) => print(e));
    }
  }
}
