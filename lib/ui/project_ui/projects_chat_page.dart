// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/theme/theme_colors.dart';
import 'package:taskify/widgets/text_field.dart';

import '../../widgets/message_design.dart';

class ProjectsChatPage extends StatefulWidget {
  final String projectName;
  const ProjectsChatPage({
    super.key,
    required this.projectName,
  });

  @override
  State<ProjectsChatPage> createState() => _ProjectsChatPageState();
}

class _ProjectsChatPageState extends State<ProjectsChatPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.grey[200],
        title: Text(widget.projectName),
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
            child: ListView.builder(
              reverse: false,
              itemCount: 50,
              physics: BouncingScrollPhysics(),
              itemBuilder: ((context, index) {
                return MessageDesign();
              }),
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    hintText: 'Write something...',
                    controller: _controller,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
