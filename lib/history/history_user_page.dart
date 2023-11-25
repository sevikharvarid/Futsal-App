import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ls_futsal/component/custom_app_bar.dart';
import 'package:ls_futsal/component/custom_card_view_history.dart';
import 'package:ls_futsal/data/model_data.dart';

class HistoryUser extends StatefulWidget {
  const HistoryUser({Key? key});

  @override
  State<HistoryUser> createState() => _HistoryUserState();
}

class _HistoryUserState extends State<HistoryUser> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        title: "History",
        backEnabled: true,
      ),
      body: FutureBuilder<List<Pesanan>>(
        future: getDataPesanan(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Pesanan> pesananList = snapshot.data ?? [];
            return ListView.builder(
              itemCount: pesananList.length,
              itemBuilder: (context, index) {
                var data = pesananList[index];
                return CustomCardViewHistory(
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
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Pesanan>> getDataPesanan(String userId) async {
    // getDataPesanan(String userId) async {
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    List<Pesanan> pesananList = [];

    try {
      DataSnapshot dataSnapshot =
          await databaseRef.child('Data Pesanan').child(userId).get();
      dynamic data = dataSnapshot.value;

      print("data is : $data");

      data.forEach((key, value) {
        Pesanan pesanan = Pesanan(
          key: key,
          tanggal: value['Tgl'],
          lapangan: value['Lapangan'],
          atasNama: value['Nama'],
          namaTeam: value['Team'],
          waktu: value['Waktu'],
          harga: value['Harga'],
          buktiBayar: value['Image'],
          isLunas: value['isLunas'],
          terbayar: value['Terbayar'],
        );
        pesananList.add(pesanan);
      });
    } catch (error) {
      print('Error fetching data from Firebase: $error');
    }

    return pesananList;
  }
}
