import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'find_friend.dart';

class UpdateProfile{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _friendID = '';
  updateProfileSocially(User user, String photoURL)async
  {
    print('updating profile socially: the url.........$photoURL');
   FindFriend friend = FindFriend();
   _firestore.collection('users').doc(user.uid).collection('friends').get().then((data)async{
     for(int i = 0; i< data.docs.length; i++)
       {
         // print('friend mail: ${data.docs[i].data()['email']} and my mail: ${user.email}');
         _friendID = await friend.findFriendID(data.docs[i].data()['email']);
         // print('friend ID: ${_friendID}');
         await _firestore.collection('users').doc(_friendID).collection('friends').doc(user.email).update({
           'photoURL': photoURL
         }).then((_) => print('added succefully................$photoURL'))
         .catchError((onError)=>print('error in adding $onError'));
       }
   });

  }
}