import 'package:flutter/material.dart';

const kSecondaryThemeColor = Colors.black54;
const kPrimaryThemeColor = Color(0xFFCED4DA);
const kDarkPrimaryThemeColor = Color(0xFF343A40);
const kLightPrimaryThemeColor = Color(0xFFF9FAFF);
const kAccentColor = Color(0xFF000000);
const kSecondaryTextColor = Color(0xFF545454);
const kBlobColor = Color(0xFFADB5BD);



const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: '  Gossip here...',
  fillColor: kLightPrimaryThemeColor,
  filled: true,
  hintStyle: TextStyle(
    fontFamily: 'NotoSans',
    color: kSecondaryTextColor,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide.none,
  )
);


const kTextFieldDecoration = InputDecoration(
  prefixIcon: Icon(Icons.mail,),
  focusColor: Colors.black,
  hintText: 'Enter a value',
  hintStyle: TextStyle(fontFamily: 'NotoSans', color: kDarkPrimaryThemeColor),
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: UnderlineInputBorder(
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide:
    BorderSide(color: kSecondaryTextColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide:
    BorderSide(color: kDarkPrimaryThemeColor, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);
const kSearchTextFieldDecoration = InputDecoration(
  prefixIcon: Icon(Icons.search, color: Colors.black, size: 30,),
  hintText: 'Search by mail',
  hintStyle: TextStyle(fontFamily: 'NotoSans', color: Colors.black),
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: InputBorder.none,
);