// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:taskify/theme/theme_colors.dart';
import 'package:taskify/ui/project_ui/projects_chat_page.dart';
import 'package:taskify/widgets/list_tile.dart';

class ProjectsChat extends StatefulWidget {
  const ProjectsChat({super.key});

  @override
  State<ProjectsChat> createState() => _ProjectsChatState();
}

class _ProjectsChatState extends State<ProjectsChat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 15,
      ),
      body: Container(
        color: Colors.white,
        //Main column layout
        child: Column(
          children: [
            //header title section.
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Disscussions',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/settings.svg',
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),

            //New messages section.
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    //Projects Section.
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, bottom: 15, top: 10),
                      child: Row(
                        children: [
                          Text(
                            'Projects',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 25,
                            width: 30,
                            decoration: BoxDecoration(
                              color: ThemeColors().grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('projects')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Text(
                                      '0',
                                      style: TextStyle(
                                        color: ThemeColors().pink,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: TextStyle(
                                        color: ThemeColors().pink,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Projects Lists.
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('projects')
                          .snapshots(),
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              var description = snapshot
                                  .data!.docs[index]['description']
                                  .toString();
                              var a = DateTime.parse(snapshot
                                  .data!.docs[index]['createDate']
                                  .toDate()
                                  .toString());
                              var time = DateFormat('d MMM y').format(a);
                              return ListTileWidget(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProjectsChatPage(
                                        projectName: snapshot.data!.docs[index]
                                            ['name'],
                                        projectId: snapshot.data!.docs[index]
                                            ['projectId'],
                                        projectLogo: snapshot.data!.docs[index]
                                            ['logoUrl'],
                                        createDate: time,
                                      ),
                                    ),
                                  );
                                },
                                appLogoUrl: snapshot.data!.docs[index]
                                    ['logoUrl'],
                                lastMessage: description,
                                title: snapshot.data!.docs[index]['name'],
                              );
                            }),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
