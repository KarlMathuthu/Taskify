// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskify/theme/theme_colors.dart';

class MessageDesign extends StatefulWidget {
  final String message;
  final String time;
  final bool isMe;
  final String senderId;
  final String projectId;
  final dynamic messageIndex;

  const MessageDesign({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
    required this.senderId,
    required this.projectId,
    required this.messageIndex,
  });

  @override
  State<MessageDesign> createState() => _MessageDesignState();
}

class _MessageDesignState extends State<MessageDesign> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  deleteMessage() async {
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('chats')
        .doc(widget.messageIndex)
        .delete();
  }

  showDeleteMsgDialog() async {
    showDialog(
      context: context,
      builder: ((_) {
        return CupertinoAlertDialog(
          title: Column(
            children: <Widget>[
              Text("Delete message"),
            ],
          ),
          content: Text("Are you sure you want to delete this message?"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(_).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Message deleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                deleteMessage();
                Navigator.of(_).pop();
              },
            ),
          ],
        );
      }),
    );
  }

  showCopyTextMsgDialog() async {
    showDialog(
      context: context,
      builder: ((_) {
        return CupertinoAlertDialog(
          title: Column(
            children: <Widget>[
              Text("Copy message"),
            ],
          ),
          content: Text("Do you want to copy this message to clipboard?"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(_).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Copy",
                style: TextStyle(
                  color: ThemeColors().blue,
                ),
              ),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: widget.message),
                ).then((_) {
                  Fluttertoast.showToast(
                    msg: "Copied to clipboard",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                });
                Navigator.of(_).pop();
              },
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return widget.isMe
        ? GestureDetector(
            onLongPress: () {
              showDeleteMsgDialog();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, top: 10, bottom: 10),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: size.width / 1.5),
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: 10, right: 8.0, top: 5, left: 5),
                      decoration: BoxDecoration(
                        color: ThemeColors().blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.message,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : GestureDetector(
            onLongPress: () {
              showCopyTextMsgDialog();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: size.width / 1.5),
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: 10, right: 8.0, top: 5, left: 5),
                      decoration: BoxDecoration(
                        color: ThemeColors().blue.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Fetch for the sender Name with senderId.
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.senderId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!.get('name') +
                                        ' ' +
                                        snapshot.data!.get('surname'),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'Username',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              }),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.message,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
