// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/theme/theme_colors.dart';
import 'package:taskify/ui/project_ui/choose_members.dart';
import 'package:taskify/ui/project_ui/create_project.dart';
import 'package:taskify/widgets/custom_widget.dart';
import 'package:taskify/widgets/widget_home.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 15,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            //Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(_auth.currentUser!.uid)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      return Text(
                        'Hello, ${snapshot.data!.get('name')}',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  }),
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/notifications.svg',
                    color: Colors.black,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            //Body layout.
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    //Blue top card.
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ThemeColors().blue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      // height: 140,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(_auth.currentUser!.uid)
                                .collection('projects')
                                .where('finished', isEqualTo: false)
                                .snapshots(),
                            builder: ((context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                return snapshot.data!.docs.length > 1
                                    ? Text(
                                        '${snapshot.data!.docs.length} projects',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : snapshot.data!.docs.isEmpty
                                        ? Text(
                                            'You have no projects',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            '${snapshot.data!.docs.length} project',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    //In progress section.
                    Row(
                      children: [
                        Text(
                          'In progress',
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
                                .collection('users')
                                .doc(_auth.currentUser!.uid)
                                .collection('projects')
                                .where('finished', isEqualTo: false)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
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
                    SizedBox(
                      height: 15,
                    ),
                    //In progress Stream bulder.
                    SizedBox(
                      height: 140,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(_auth.currentUser!.uid)
                            .collection('projects')
                            .where('finished', isEqualTo: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: ((context, index) {
                                var a = DateTime.parse(snapshot
                                    .data!.docs[index]['createDate']
                                    .toDate()
                                    .toString());
                                var time = DateFormat('d MMM y').format(a);
                                return CustomContainer(
                                  description: snapshot.data!.docs[index]
                                      ['description'],
                                  title: snapshot.data!.docs[index]['name'],
                                  createDate: time,
                                );
                              }),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Finished projects',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(_auth.currentUser!.uid)
                              .collection('projects')
                              .where('finished', isEqualTo: true)
                              .snapshots(),
                          builder: ((context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              return Container(
                                height: 25,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: ThemeColors().grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                      color: ThemeColors().pink,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                    //Listview builder.
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .collection('projects')
                          .where('finished', isEqualTo: true)
                          .snapshots(),
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: ((context, index) {
                              var a = DateTime.parse(snapshot
                                  .data!.docs[index]['createDate']
                                  .toDate()
                                  .toString());
                              var time = DateFormat('d MMM y').format(a);
                              return WidgetHome(
                                description: (snapshot.data!.docs[index]
                                    ['description']),
                                progress_percentage: '100',
                                createDate: time,
                                title: (snapshot.data!.docs[index]['name']),
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
      //New project floating action button.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) {
                return ChooseMembers();
              }),
            ),
          );
        },
        backgroundColor: ThemeColors().blue,
        label: Text(
          'New project',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
