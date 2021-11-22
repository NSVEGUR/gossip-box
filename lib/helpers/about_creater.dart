import 'package:flutter/material.dart';
import 'package:gossip_box/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:blobs/blobs.dart';

showAboutCreator(context) {
  return showDialog(
      context: context,
      builder: (context){
        return Center(
          child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kBlobColor,
                ),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 300,
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      bottom: -50,
                      child: Blob.random(
                        size: 180,
                        styles: BlobStyles(
                          color: Color(0xFF6c757d).withOpacity(0.5),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -50,
                      top: -50,
                      child: Blob.random(
                        size: 180,
                        styles: BlobStyles(
                          color: Color(0xFF6c757d).withOpacity(0.5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset('images/creator.jpeg', fit: BoxFit.cover, height: 100, width: 100),
                          ),
                          SizedBox(height: 20,),
                          Flexible(child: Lottie.asset('assets/watch.json', height: 30)),
                          // SizedBox(height: 20,),
                          Row(
                            children: [
                              Text(
                                  'Creator: ',
                                  style: TextStyle(
                                    color: kSecondaryTextColor,
                                    fontFamily: 'NotoSans',
                                    fontSize: 20,
                                  )
                              ),
                              Text(
                                  'NSVegur',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'NotoSans',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text(
                                  'Contact: ',
                                  style: TextStyle(
                                    color: kSecondaryTextColor,
                                    fontFamily: 'NotoSans',
                                    fontSize: 20,
                                  )
                              ),
                              Flexible(
                                child: Text(
                                    'nsvegur@gmail.com',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'NotoSans',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
        );
      }

  );
}