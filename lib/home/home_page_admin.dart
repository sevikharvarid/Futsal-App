import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ls_futsal/component/custom_app_bar.dart';
import 'package:ls_futsal/component/custom_card_view_history.dart';
import 'package:ls_futsal/component/nav_drawer_admin.dart';
import 'package:ls_futsal/data/model_data.dart';
import 'package:ls_futsal/detail/detail_page_admin.dart';

class HomePageAdmin extends StatefulWidget {
  final String? userName;
  final String? email;
  const HomePageAdmin({
    Key? key,
    this.userName,
    this.email,
  });

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _refreshData() async {
    // _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: DrawerWidgetAdmin(
        accountName: widget.userName,
        accountEmail: widget.email,
        onTapDataLapangan: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/dataLapangan');
        },
        onTapLogout: () {
          Navigator.popUntil(
            context,
            (route) => route.settings.name == '/login',
          );
        },
        onTapLaporan: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/report');
        },
      ),
      appBar: CustomAppBar(
        title: "Home Page Admin",
        backEnabled: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<PesananUser>>(
          future: getDataPesanan(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<PesananUser> pesananList = snapshot.data ?? [];
              return ListView.builder(
                itemCount: pesananList.length,
                itemBuilder: (context, index) {
                  var data = pesananList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DetailPageAdmin(
                                    lapangan: data.lapangan,
                                    totalCost: data.harga.toString(),
                                    listWaktu: data.waktu
                                        .replaceAll('[', '')
                                        .replaceAll(']', '')
                                        .split(',')
                                        .map((time) => time.trim())
                                        .toList(),
                                    atasName: data.atasNama,
                                    namaTeam: data.namaTeam,
                                    tanggalAwal: data.tanggal,
                                    buktiBayar: data.buktiBayar,
                                    userId: data.userId,
                                    keyId: data.key,
                                  )));
                    },
                    child: CustomCardViewHistory(
                      status: data.isLunas,
                      title: data.lapangan,
                      image: data.lapangan == 'Lapangan 1'
                          ? 'assets/images/lap1A.jpeg'
                          : data.lapangan == 'Lapangan 2'
                              ? 'assets/images/lap2A.jpeg'
                              : 'assets/images/lap3A.jpeg',
                      nama: data.atasNama,
                      tanggal: data.tanggal,
                      waktu: data.waktu,
                      nilaiTerbayar: data.terbayar,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  // Future<List<PesananUser>> getDataPesanan() async {
  Future<List<PesananUser>> getDataPesanan() async {
    // getDataPesanan() async {
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    List<PesananUser> pesananList = [];

    try {
      DataSnapshot dataSnapshot = await databaseRef.child('Data Pesanan').get();
      dynamic data = dataSnapshot.value;

      print("data is : $data");

      data.forEach((userId, datas) {
        datas.forEach((key, value) {
          PesananUser pesanan = PesananUser(
            userId: userId,
            key: key,
            tanggal: value['Tgl'],
            lapangan: value['Lapangan'],
            atasNama: value['Nama'],
            namaTeam: value['Team'],
            waktu: value['Waktu'],
            noHp: value['NoHp'].toString(),
            harga: value['Harga'],
            buktiBayar: value['Image'],
            isLunas: value['isLunas'],
            terbayar: value['Terbayar'],
          );
          pesananList.add(pesanan);
        });
      });
    } catch (error) {
      print('Error fetching data from Firebase: $error');
    }

    return pesananList;
  }
}
