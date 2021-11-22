import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gossip_box/screens/add_friends_screen.dart';

final _firestore = FirebaseFirestore.instance;

class FindFriend {
  String ID = '';
  String messageID = '';

  Future<bool> checkExistance(String mail, String uid) async {
    // print('Checking Friend Existance');
    bool exist = false;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .get()
        .then((data) => {
              for (int i = 0; i < data.docs.length; i++)
                {
                  // print(data.docs[i].data())
                  if (mail == data.docs[i].data()['email']) exist = true
                }
            })
        .catchError((e) => print(e));
    return exist;
  }

  Future<String> findFriendID(String mail) async {
    // print('holy mother of god..................');
    print('Friend is ${mail}');
    String id = '';
    await _firestore
        .collection('users')
        .get()
        .then((data) {
      // print('friends');
      for (int i = 0; i < data.docs.length; i++) {
        // print(data.docs[i].data()['email']);
        // print('id:  ${data.docs[i].id}');
        if(mail == data.docs[i].data()['email'])
          id = data.docs[i].id;
      }
    }).catchError((e) => print(e));
    ID = id;
    return id;
  }

  Future<String> findFriendPhotoURL(String mail) async {
    // print('holy mother of god..................');
    print('Friend is ${mail}');
    String url = '';
    await _firestore
        .collection('users')
        .get()
        .then((data) {
      // print('friends');
      for (int i = 0; i < data.docs.length; i++) {
        // print(data.docs[i].data()['email']);
        // print('id:  ${data.docs[i].id}');
        if(mail == data.docs[i].data()['email'])
          url = data.docs[i].data()['photoURL'];
      }
    }).catchError((e) => print(e));
    return url;
  }

}
