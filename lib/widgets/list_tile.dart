import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:taskify/theme/theme_colors.dart';
import 'package:badges/badges.dart' as badges;
class ListTileWidget extends StatelessWidget {
  final String title;
  final String lastMessage;
  final String appLogoUrl;

  final dynamic? onTap;
  const ListTileWidget({
    super.key,
    required this.title,
    required this.lastMessage,
    required this.appLogoUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: ThemeColors().blue,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(appLogoUrl),
            ),
          ),
        ),
        
        title: Text(title),
        subtitle: Text(lastMessage),
        trailing: badges.Badge(
          badgeStyle: BadgeStyle(
            badgeColor: ThemeColors().blue,
          ),
        ),
      ),
    );
  }
}
