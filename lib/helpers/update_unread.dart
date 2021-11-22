import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'find_friend.dart';

class UpdateUnread
{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FindFriend friend = FindFriend();
  String _friendID = '';
  int unread = 0;
  removeUnreadInMe({required User loggedInUser, required String friendMail})async
  {
    print('removing unread in me.........');
   await _firestore.collection('users').doc(loggedInUser.uid).collection('friends').doc(friendMail).update({
     'unread': 0,
   });
  }

  Future<int> getUnreadInFriend({required String friendMail, required myMail})async{
    _friendID = await friend.findFriendID(friendMail);
    print('getting unread in friend....$_friendID');
    await _firestore.collection('users').doc(_friendID).collection('friends').doc(myMail).get().then((data){
      unread = data['unread'];
    });
    print('unread in friend.............$unread');
    return unread;
  }

  updateUnreadInFriend({required String friendMail, required myMail, required numberOfUnread})async
  {
    _friendID = await friend.findFriendID(friendMail);
    print('updating unread in friend....$_friendID');
    await _firestore.collection('users').doc(_friendID).collection('friends').doc(myMail).update({
      'unread': numberOfUnread
    });
    print('unread in friend.............$numberOfUnread');
  }
}