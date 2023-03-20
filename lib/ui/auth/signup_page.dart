// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskify/resources/auth_res.dart';
import 'package:taskify/theme/theme_colors.dart';
import 'package:taskify/ui/home/main_home.dart';
import 'package:taskify/widgets/custom_button.dart';
import 'package:taskify/widgets/custom_loader.dart';
import 'package:taskify/widgets/text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final CustomLoader _loader = CustomLoader();

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  var avatars = [
    'https://firebasestorage.googleapis.com/v0/b/webtaskify.appspot.com/o/avatars%2Fface1.png?alt=media&token=b5fa5548-7e81-4ef0-9fa8-5bbb569ff7c9',
    'https://firebasestorage.googleapis.com/v0/b/webtaskify.appspot.com/o/avatars%2Fface19.png?alt=media&token=8f261f37-b1e9-432d-9d98-21d57991a63f',
    'https://firebasestorage.googleapis.com/v0/b/webtaskify.appspot.com/o/avatars%2Fface30.png?alt=media&token=7126973c-90b4-44bb-83fa-f5d8e19b181f',
    'https://firebasestorage.googleapis.com/v0/b/webtaskify.appspot.com/o/avatars%2Fface34.png?alt=media&token=fe0bf267-b63b-4122-8aae-80fdf498a4e4',
    'https://firebasestorage.googleapis.com/v0/b/webtaskify.appspot.com/o/avatars%2Fface43.png?alt=media&token=ab4c2b6f-9596-4768-a59d-f42d0d30627f',
    'https://firebasestorage.googleapis.com/v0/b/webtaskify.appspot.com/o/avatars%2Fface5.png?alt=media&token=bf6a0a26-1aa7-4916-8696-43bc8b52e30e',
  ];

  createAccount() async {
    var avatarList = avatars[Random().nextInt(avatars.length)];
    String name = _name.text.toString().trim();
    String surname = _surname.text.toString().trim();
    String email = _email.text.toString().trim();
    String password = _password.text.toString().trim();

    String res = await AuthRes().createAccount(
      name,
      surname,
      email,
      avatarList,
      password,
    );

    if (res == 'success') {
      _loader.hideLoader();
      Navigator.pop(context);
    } else {
      _loader.hideLoader();
      Fluttertoast.showToast(
        msg: res,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Create account to continue...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                controller: _name,
                hintText: 'Name',
                prefixIcon: SvgPicture.asset(
                  'assets/icons/person.svg',
                  fit: BoxFit.none,
                ),
              ),
              TextFieldWidget(
                controller: _surname,
                hintText: 'Surname',
                prefixIcon: SvgPicture.asset(
                  'assets/icons/person.svg',
                  fit: BoxFit.none,
                ),
              ),
              TextFieldWidget(
                controller: _email,
                hintText: 'Email',
                prefixIcon: SvgPicture.asset(
                  'assets/icons/email.svg',
                  fit: BoxFit.none,
                ),
              ),
              TextFieldWidget(
                controller: _password,
                hintText: 'Password',
                prefixIcon: SvgPicture.asset(
                  'assets/icons/lock.svg',
                  fit: BoxFit.none,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                text: 'Create Account',
                onTap: () {
                  _loader.showLoader(context);
                  createAccount();
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Center(
                    child: Text('Login'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
