import 'package:cloud_firestore/cloud_firestore.dart';

class UserExistance{
  bool exist = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  checkExistance(String mail)async{
    await _firestore
        .collection('users')
        .get()
        .then((data) => {
      for(int i = 0;i<data.docs.length;i++)
        {
          // print(data.docs[i].data())
          if(mail == data.docs[i].data()['email'])
            exist = true
        }
    })
        .catchError((e) => print(e));
  }
}