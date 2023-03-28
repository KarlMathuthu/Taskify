// ignore_for_file: prefer_const_constructors

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskify/ui/project_ui/create_project.dart';
import 'package:taskify/widgets/text_field.dart';

import '../../theme/theme_colors.dart';

class ChooseMembers extends StatefulWidget {
  const ChooseMembers({
    super.key,
  });

  @override
  State<ChooseMembers> createState() => _ChooseMembersState();
}

class _ChooseMembersState extends State<ChooseMembers> {
  bool isSelected = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> membersList = [];
  Map<String, dynamic>? userMap;

  onSearch() async {
    if (_controller.text.trim().toLowerCase().isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .where(
              'email',
              isEqualTo: _controller.text.toLowerCase(),
            )
            .get()
            .then((value) {
          setState(() {
            userMap = value.docs[0].data();
          });
        });
      } catch (error) {
        Fluttertoast.showToast(
          msg: 'User not found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {}
  }

  getCurrentUserDetails() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        membersList.add({
          'name': map['name'],
          'email': map['email'],
          'uid': map['uid'],
          'photoUrl': map['photoUrl'],
        });
      });
    });
  }

  onResultTap() async {
    bool memberAlreadyExists = false;
    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap!['uid']) {
        memberAlreadyExists = true;
      }
    }
    if (!memberAlreadyExists) {
      setState(() {
        membersList.add({
          'name': userMap!['name'],
          'uid': userMap!['uid'],
          'photoUrl': userMap!['photoUrl'],
          'email': userMap!['email'],
        });
        userMap = null;
      });
    } else {
      Fluttertoast.showToast(
          msg: "Member already axists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  onRemoveMember(int index) async {
    if (membersList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    } else {
      Fluttertoast.showToast(
          msg: "You can't remove yourself",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    getCurrentUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          'Choose Members',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: membersList.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(
                    membersList[index]['name'],
                  ),
                  trailing: IconButton(
                    onPressed: () => onRemoveMember(index),
                    icon: Icon(Icons.close),
                  ),
                  subtitle: Text(
                    membersList[index]['email'],
                  ),
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: ThemeColors().grey,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(
                          membersList[index]['photoUrl'],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            TextFieldWidget(
              onSubmitted: (value) {
                onSearch();
              },
              suffixIcon: IconButton(
                onPressed: () {
                  onSearch();
                },
                icon: SvgPicture.asset(
                  'assets/icons/search.svg',
                  fit: BoxFit.none,
                ),
              ),
              controller: _controller,
              hintText: 'Search members',
              prefixIcon: SvgPicture.asset(
                'assets/icons/person.svg',
                fit: BoxFit.none,
              ),
            ),
            userMap != null
                ? ListTile(
                    onTap: onResultTap,
                    title: Text(
                      userMap!['name'],
                    ),
                    subtitle: Text(
                      userMap!['email'],
                    ),
                    trailing: Icon(Icons.add),
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: ThemeColors().grey,
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(
                            userMap!['photoUrl'],
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
              backgroundColor: ThemeColors().blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalProject(
                      membersList: membersList,
                    ),
                  ),
                );
                //Navigator.pop(context);
              },
              child: Icon(Icons.arrow_forward),
            )
          : SizedBox(),
    );
  }
}
