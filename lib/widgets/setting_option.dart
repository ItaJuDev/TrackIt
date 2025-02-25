import 'package:flutter/material.dart';

class SettingOption extends StatelessWidget {
  final String title;
  final IconData trailingIcon;
  final VoidCallback onTap;

  const SettingOption({
    Key? key,
    required this.title,
    this.trailingIcon = Icons.chevron_right,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: Icon(trailingIcon),
          onTap: onTap,
        ),
        Divider(height: 10, color: Colors.transparent),
      ],
    );
  }
}
