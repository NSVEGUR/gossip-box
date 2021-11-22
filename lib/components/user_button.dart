import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gossip_box/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

String userImage(String user)=>user[0].toLowerCase();

 Widget UserButton({required userName, required email, required onPressed, required photoURL, required unread})
 {
   print('unread: $unread');
   // print('photo URL in user button $userName: .............$photoURL');
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: Material(
         elevation: 5.0,
         color: kLightPrimaryThemeColor,
         borderRadius: BorderRadius.circular(10.0),
         child:  FlatButton(
           onPressed: () {
             onPressed();
           },
           minWidth: double.infinity,
           height: 55.0,
           child: Row(
             children: [
               ClipOval(
                   child: photoURL!=null?Image.network(photoURL,
                     height: 35, width:35, fit: BoxFit.cover,)   :Image.asset(
                     'images/user.png',
                     height: 35,
                     fit: BoxFit.cover,
                   ),
                 ),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.only(left: 10),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         userName,
                         style: TextStyle(
                           fontFamily: 'QuickSand',
                           fontSize: 20,
                           color: Colors.black,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                       Text(
                         email,
                         style: TextStyle(
                           fontFamily: 'NotoSans',
                           fontSize: 10,
                           color: kSecondaryTextColor,
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
               unread == 0? Container(): ClipOval(
                 child: Container(
                   child: Text(unread.toString(), style: TextStyle(
                     color: Colors.white,
                   ),
                     textAlign: TextAlign.center,
                   ),
                   height: 20,
                   width: 20,
                   color: Colors.black,
                 ),
               )
             ],
           ),
         ),
       ),
     );
 }

