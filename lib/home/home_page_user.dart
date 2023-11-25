import 'package:flutter/material.dart';
import 'package:ls_futsal/component/custom_card_view.dart';
import 'package:ls_futsal/component/nav_drawer_user.dart';
import 'package:ls_futsal/history/history_user_page.dart';

import '../component/custom_app_bar.dart';
import '../detail/detail_page_user.dart';

class HomePageUser extends StatefulWidget {
  final String? userName;
  final String? email;
  const HomePageUser({
    Key? key,
    this.userName,
    this.email,
  });

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> lapangan1 = [
    'assets/images/lap1A.jpeg',
    'assets/images/lap1B.jpeg',
    'assets/images/lap1C.jpeg',
  ];
  List<String> lapangan2 = [
    'assets/images/lap2A.jpeg',
    'assets/images/lap2B.jpeg',
    'assets/images/lap2C.jpeg',
  ];
  List<String> lapangan3 = [
    'assets/images/lap3A.jpeg',
    'assets/images/lap3B.jpeg',
    'assets/images/lap3C.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(
        accountName: widget.userName,
        accountEmail: widget.email,
        onTapLogout: () {
          Navigator.popUntil(
            context,
            (route) => route.settings.name == '/login',
          );
        },
        onTapHistory: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HistoryUser()));
        },
        onTapAccount: () {},
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => const DetailPageUser())));
        },
      ),
      appBar: CustomAppBar(
        title: "Home Page User",
        backEnabled: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 16,
          right: 10,
          left: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: ListView.builder(
                                itemCount: lapangan1.length,
                                itemBuilder: (context, index) {
                                  return Image.asset(
                                    lapangan1[index],
                                    fit: BoxFit.cover,
                                  );
                                }),
                          );
                        },
                      );
                    },
                    child: const CustomCardView(
                      image: "assets/images/lap1A.jpeg",
                      title: "Lapangan 1",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return ListView.builder(
                              itemCount: lapangan2.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Image.asset(
                                    lapangan2[index],
                                    fit: BoxFit.cover,
                                  ),
                                );
                              });
                        },
                      );
                    },
                    child: const CustomCardView(
                      image: "assets/images/lap2A.jpeg",
                      title: "Lapangan 2",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return ListView.builder(
                              itemCount: lapangan3.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Image.asset(
                                    lapangan3[index],
                                    fit: BoxFit.cover,
                                  ),
                                );
                              });
                        },
                      );
                    },
                    child: const CustomCardView(
                      image: "assets/images/lap3A.jpeg",
                      title: "Lapangan 3",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
