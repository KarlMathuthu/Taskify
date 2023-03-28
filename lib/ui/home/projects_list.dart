// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/theme/theme_colors.dart';
import 'package:taskify/widgets/list_container.dart';

class ProjectsList extends StatefulWidget {
  const ProjectsList({super.key});

  @override
  State<ProjectsList> createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Color> _list = [
    ThemeColors().blue,
    ThemeColors().pink,
    ThemeColors().purple,
    ThemeColors().purpleAccent,
    ThemeColors().yellow,
  ];

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
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              //Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My projects',
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
              SizedBox(
                height: 25,
              ),
              //Body
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(_auth.currentUser!.uid)
                      .collection('projects')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          var colorsList =
                              _list[Random().nextInt(_list.length)];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ListContainer(
                              colorsList: colorsList,
                              illustration: snapshot.data!.docs[index]
                                  ['illustration'],
                              description: snapshot.data!.docs[index]
                                  ['description'],
                              title: snapshot.data!.docs[index]['name'],
                              logourl: snapshot.data!.docs[index]['logoUrl'],
                            ),
                          );
                        }),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
