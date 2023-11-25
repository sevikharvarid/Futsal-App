import 'package:flutter/material.dart';
import 'package:ls_futsal/component/home_drawer_header.dart';

class DrawerWidgetAdmin extends StatelessWidget {
  Function()? onTapLogout;
  Function()? onTapDataLapangan;
  Function()? onTapLaporan;
  String? accountName;
  String? accountEmail;

  DrawerWidgetAdmin({
    Key? key,
    this.onTapLogout,
    this.onTapDataLapangan,
    this.onTapLaporan,
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
          _drawerItem(
            icon: Icons.dashboard_customize_sharp,
            text: 'Laporan',
            onTap: onTapLaporan,
          ),
          _drawerItem(
            icon: Icons.border_all_sharp,
            text: 'Data Lapangan',
            onTap: onTapDataLapangan,
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
