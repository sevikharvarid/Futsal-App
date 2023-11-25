import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ls_futsal/component/custom_app_bar.dart';
import 'package:ls_futsal/component/input_text_field.dart';
import 'package:ls_futsal/component/pdf_report_api.dart';
import 'package:ls_futsal/component/pdf_viewer.dart';
import 'package:ls_futsal/data/lapangan_data.dart';
import 'package:ls_futsal/data/model_data.dart';
import 'package:ls_futsal/data/user_data.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportPage extends StatefulWidget {
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  TextEditingController reportType = TextEditingController();

  List<String> datax = [];
  bool? isLoading = false;
  int? currentIndex = 0;
  List<String>? dropdownItems = [
    'Data Lapangan',
    'Laporan Data Pelanggan',
    'Laporan Pemesanan',
    'Laporan Pembayaran'
  ];

  _convertDatabaseToCSV(String? reportTitle, int? type) async {
    setState(() {
      isLoading = true;
    });
    List<PesananUser> pesananList = [];
    DataSnapshot dataSnapshot = await databaseRef.child('Data Pesanan').get();
    dynamic data = dataSnapshot.value;
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

    List<UserData> userList = [];
    DataSnapshot dataSnapshotUser = await databaseRef.child('users').get();
    dynamic dataUser = dataSnapshotUser.value;
    dataUser.forEach((userId, datas) {
      UserData userData = UserData(
        alamat: datas['alamat'],
        userName: datas['username'],
        email: datas['email'],
      );
      userList.add(userData);
    });

    List<DataLapangan> dataLapanganList = [];
    DataSnapshot dataSnapshotLapangan =
        await databaseRef.child('Data Lapangan').get();
    dynamic dataDataLapangan = dataSnapshotLapangan.value;
    dataDataLapangan.forEach((key, datas) {
      DataLapangan lapanganData = DataLapangan(
        lapangan: key,
        keterangan: datas['keterangan'],
        stokBola: datas['stokBola'],
      );
      dataLapanganList.add(lapanganData);
    });
    String dateTimeNow = DateFormat('d MMMM y').format(DateTime.now());
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final pdf = await PdfInvoiceApi().generate(
        reportTitle!,
        pesananList,
        userList,
        dataLapanganList,
        dateTimeNow,
        type,
      );
      if (pdf != null) {
        print("Success");
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportViewer(
              report: pdf,
            ),
          ),
        );
      } else {
        print("Galat");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("Not Allowed !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Report Page",
        backEnabled: false,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                spreadRadius: 1,
                blurRadius: 2,
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputTextField(
              labelTitle: "Tipe Laporan",
              controller: reportType,
              hint: "Pilih laporan",
              isVisible: false,
              isPassword: false,
              isDropDown: true,
              dropdownItems: dropdownItems,
              onChangedDropdown: (selected) {
                setState(() {
                  currentIndex = dropdownItems!.indexOf(selected);
                });
              },
              onPressedSuffixIcon: () {},
            ),
            !isLoading!
                ? InkWell(
                    // onTap: () => _convertDatabaseToCSV()
                    onTap: () {
                      if (currentIndex == 0) {
                        _convertDatabaseToCSV(dropdownItems![0], 0);
                      } else if (currentIndex == 1) {
                        _convertDatabaseToCSV(dropdownItems![1], 1);
                      } else if (currentIndex == 2) {
                        _convertDatabaseToCSV(dropdownItems![2], 2);
                      } else if (currentIndex == 3) {
                        _convertDatabaseToCSV(dropdownItems![3], 3);
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              spreadRadius: 1,
                              blurRadius: 3,
                            ),
                          ]),
                      child: const Center(
                        child: Text(
                          "Proses",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
