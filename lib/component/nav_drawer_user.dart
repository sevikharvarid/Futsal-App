import 'package:flutter/material.dart';
import 'package:ls_futsal/component/home_drawer_header.dart';

class DrawerWidget extends StatelessWidget {
  Function()? onTapLogout;
  Function()? onTapAccount;
  Function()? onTapHistory;
  String? accountName;
  String? accountEmail;

  DrawerWidget({
    Key? key,
    this.onTapLogout,
    this.onTapAccount,
    this.onTapHistory,
    this.accountName,
    this.accountEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _drawerHeader(
            accountName: accountName,
            accountEmail: accountEmail,
          ),
          // _drawerItem(
          //   icon: Icons.person,
          //   text: 'Account',
          //   onTap: onTapAccount,
          // ),
          _drawerItem(
            icon: Icons.history,
            text: 'History',
            onTap: onTapHistory,
          ),
          const Divider(height: 25, thickness: 1),
          _drawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: onTapLogout,
          ),
        ],
      ),
    );
  }
}

Widget _drawerHeader({String? accountName, String? accountEmail}) {
  return HomeDrawer(
    backgroundColor: Colors.green,
    accountName: Text(accountName!),
    accountEmail: Text(accountEmail!),
  );
}

Widget _drawerItem({IconData? icon, String? text, GestureTapCallback? onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            text!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    onTap: onTap,
  );
}
