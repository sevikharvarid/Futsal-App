import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backEnabled;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar(
      {Key? key,
      required this.title,
      this.backEnabled = true,
      this.actions,
      this.leading})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      leading: backEnabled
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back))
          : leading,
      actions: actions,
      title: Text(title),
    );
  }
}
