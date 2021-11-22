import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants.dart';

String userImage(String user) => user[0].toLowerCase();

class FriendButton extends StatefulWidget {
  FriendButton(
      {this.userName,
      this.email,
      this.state,
      required this.add,
      required this.remove,
      required this.accept,
      required this.reject});
  final userName;
  final email;
  final state;
  final Function add;
  final Function remove;
  final Function accept;
  final Function reject;
  @override
  _FriendButtonState createState() => _FriendButtonState(
      userName: userName,
      email: email,
      state: state,
      add: add,
      remove: remove,
      accept: accept,
      reject: reject);
}

class _FriendButtonState extends State<FriendButton> {
  _FriendButtonState(
      {this.userName,
      this.email,
      this.state,
      required this.add,
      required this.remove,
      required this.accept,
      required this.reject});
  final userName;
  final email;
  final state;
  final Function add;
  final Function remove;
  final Function accept;
  final Function reject;
  bool _changeState = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5.0,
        color: kLightPrimaryThemeColor,
        borderRadius: BorderRadius.circular(10.0),
        child: FlatButton(
          onPressed: () {},
          minWidth: double.infinity,
          height: 55.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipOval(
                child: Image.asset(
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
                          fontWeight: FontWeight.w700,
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
              state
                  ? Expanded(
                      flex: 0,
                      child: Material(
                        elevation: 5.0,
                        clipBehavior: Clip.antiAlias,
                        color: _changeState ? kPrimaryThemeColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                          height: 20,
                          child: MaterialButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            height: 10,
                            onPressed: () {
                              setState(() {
                                if (_changeState == true) {
                                  _changeState = false;
                                  add();
                                } else {
                                  _changeState = true;
                                  remove();
                                }
                              });
                            },
                            clipBehavior: Clip.antiAlias,
                            child: Text(
                              _changeState ? '+ request' : 'requested',
                              style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontSize: 10,
                                color: _changeState ? Colors.black: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      flex: 0,
                      child: Material(
                        elevation: 5.0,
                        clipBehavior: Clip.antiAlias,
                        color: _changeState ? kPrimaryThemeColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                          height: 20,
                          child: MaterialButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            height: 10,
                            onPressed: () {
                              setState(() {
                                if (_changeState == true) {
                                  _changeState = false;
                                  accept();
                                } else {
                                  _changeState = true;
                                  reject();
                                }
                              });
                            },
                            clipBehavior: Clip.antiAlias,
                            child: Text(
                              _changeState ? '+ accept' : 'accepted',
                              style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontSize: 10,
                                color: _changeState ? Colors.black: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
