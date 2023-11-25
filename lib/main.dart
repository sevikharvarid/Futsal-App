import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ls_futsal/detail/detail_page_admin.dart';
import 'package:ls_futsal/detail/detail_page_user.dart';
import 'package:ls_futsal/detail/input_data_lapangan.dart';
import 'package:ls_futsal/history/history_user_page.dart';
import 'package:ls_futsal/home/home_page_admin.dart';
import 'package:ls_futsal/home/home_page_user.dart';
import 'package:ls_futsal/login/login_page.dart';
import 'package:ls_futsal/report/report_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/homeUser': (context) => const HomePageUser(),
        '/homeAdmin': (context) => const HomePageAdmin(),
        '/historyUser': (context) => const HistoryUser(),
        '/detailUser': (context) => const DetailPageUser(),
        '/detailAdmin': (context) => const DetailPageAdmin(),
        '/report': (context) => ReportPage(),
        '/dataLapangan': (context) => DataLapanganPage(),
      },
    );
  }
}
