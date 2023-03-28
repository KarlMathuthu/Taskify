// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:taskify/theme/theme_colors.dart';
import 'package:taskify/widgets/bottom_container_chat.dart';
import 'package:taskify/widgets/custom_button.dart';

import '../../widgets/message_design.dart';

class ProjectsChatPage extends StatefulWidget {
  final String projectName;
  final String projectId;
  final String projectLogo;
  final String createDate;
  const ProjectsChatPage({
    super.key,
    required this.projectName,
    required this.projectId,
    required this.projectLogo,
    required this.createDate,
  });

  @override
  State<ProjectsChatPage> createState() => _ProjectsChatPageState();
}

class _ProjectsChatPageState extends State<ProjectsChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors().grey,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: ThemeColors().blue,
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.projectLogo),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.projectName),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('assets/icons/settings.svg'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            color: ThemeColors().purpleAccent.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '${widget.projectName} was created',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    widget.createDate,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('projects')
                          .doc(widget.projectId)
                          .collection('chats')
                          .orderBy('date', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: ((context, index) {
                              var a = DateTime.parse(snapshot
                                  .data!.docs[index]['date']
                                  .toDate()
                                  .toString());
                              var time = DateFormat('HH:mm').format(a);

                              bool isMe = snapshot.data!.docs[index]
                                      ['senderId'] ==
                                  _auth.currentUser!.uid;

                              return MessageDesign(
                                isMe: isMe,
                                message: snapshot.data!.docs[index]['message'],
                                time: time,
                                senderId: snapshot.data!.docs[index]
                                    ['senderId'],
                                projectId: widget.projectId,
                                messageIndex: snapshot.data!.docs[index].id,
                              );
                            }),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ],
              ),
            ),
          ),
          //Bottom Container
          BottomContainerChat(
            projectId: widget.projectId,
          ),
        ],
      ),
    );
  }
}
