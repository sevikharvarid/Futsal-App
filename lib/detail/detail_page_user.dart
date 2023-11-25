import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ls_futsal/component/input_text_field.dart';
import 'package:ls_futsal/data/app_data.dart';
import 'package:ls_futsal/result/payment.dart';

import '../component/custom_app_bar.dart';

class DetailPageUser extends StatefulWidget {
  const DetailPageUser({Key? key});

  @override
  State<DetailPageUser> createState() => _DetailPageUserState();
}

class _DetailPageUserState extends State<DetailPageUser> {
  List<String> images = [
    "assets/images/fieldA.png",
    "assets/images/fieldA.png",
    "assets/images/fieldA.png"
  ];
  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.black,
  ];

  TextEditingController namaTeam = TextEditingController();
  TextEditingController atasNama = TextEditingController();
  TextEditingController lapangan = TextEditingController();
  TextEditingController tglAwal = TextEditingController();
  TextEditingController jamAwal = TextEditingController();
  TextEditingController tglAkhir = TextEditingController();
  TextEditingController jamAkhir = TextEditingController();
  TextEditingController noHp = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<bool>? isTimeClick = List.generate(14, (index) => false);
  List<dynamic> priceData = [];
  List<dynamic> listWaktu = [];
  bool? isWeekDay = false;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      print("weekday is : $isWeekDay");
    });
  }

  void saveDataToFirebase(
    String namaTeam,
    String atasNama,
    String lapangan,
    int totalPrice,
    String tanggalAwal,
    String listJam,
  ) {
    // Ambil referensi database
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

    // Simpan data pemesanan ke database
    databaseRef.child('Data Pemesanan').child(lapangan).child(tanggalAwal).set({
      'namaTeam': namaTeam,
      'atasNama': atasNama,
      'totalPrice': totalPrice,
      'payment': 0,
      'listJam': listJam,
    }).then((_) {
      print('Data pemesanan berhasil disimpan ke database');
    }).catchError((error) {
      print('Gagal menyimpan data pemesanan ke database: $error');
    });
  }

  String changeDateFormat(String inputDate) {
    DateTime dateTime = DateFormat('dd/MM/yyyy').parse(inputDate);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  // Future<bool> isListJamSame(
  isListJamSame(String tanggal, List<dynamic> listJam, String lapangan) async {
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await databaseRef
        .child('Data Pemesanan')
        .child(lapangan)
        .child(tanggal)
        .child('listJam')
        .get();
    if (snapshot.value == null) {
      return true;
    }
    String? databaseListJam = snapshot.value as String?;
    List<dynamic> dynamicList =
        List<dynamic>.from(json.decode(databaseListJam!));

    if (listJam.length != dynamicList.length) {
      return false;
    }

    // Cek apakah ada setidaknya satu elemen yang sama di antara dua list
    bool hasSameIndexTrue = false;
    for (int i = 0; i < listJam.length; i++) {
      if (listJam[i] == true && dynamicList[i] == true) {
        hasSameIndexTrue = true;
        break;
      }
    }

    return !hasSameIndexTrue;
  }

  // bool isListJamSame(List<bool> listA, List<bool> listB) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        title: "Detail",
        backEnabled: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InputTextField(
                    labelTitle: "Nama Team",
                    controller: namaTeam,
                    hint: "",
                    isVisible: false,
                    isPassword: false,
                    onPressedSuffixIcon: () {},
                  ),
                  InputTextField(
                    labelTitle: "Atas Nama",
                    controller: atasNama,
                    hint: "",
                    isVisible: false,
                    isPassword: false,
                    onPressedSuffixIcon: () {},
                  ),
                  InputTextField(
                    labelTitle: "No. HP",
                    controller: noHp,
                    hint: "",
                    isVisible: false,
                    isPassword: false,
                    onPressedSuffixIcon: () {},
                  ),
                  InputTextField(
                    labelTitle: "Lapangan",
                    controller: lapangan,
                    hint: "",
                    isVisible: false,
                    isPassword: false,
                    isDropDown: true,
                    dropdownItems: const [
                      'Lapangan 1',
                      'Lapangan 2',
                      'Lapangan 3'
                    ],
                    onChangedDropdown: (selected) {
                      setState(() {
                        print("selected item : $selected");
                      });
                      lapangan.text = selected;
                    },
                    onPressedSuffixIcon: () {},
                  ),
                  InputTextField(
                    labelTitle: "Tanggal Booking",
                    controller: tglAwal,
                    hint: "",
                    isVisible: false,
                    isPassword: false,
                    isReadOnly: true,
                    isCalendarMonth: true,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 6)),
                      ).then((pickedDate) {
                        int dayOfWeek = pickedDate!.weekday;
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                        tglAwal.text = formattedDate;
                        if (dayOfWeek == DateTime.monday ||
                            dayOfWeek == DateTime.tuesday ||
                            dayOfWeek == DateTime.wednesday ||
                            dayOfWeek == DateTime.thursday ||
                            dayOfWeek == DateTime.friday) {
                          setState(() {
                            priceData = AppData().priceDataWeekday;
                            isWeekDay = true;
                          });
                          print("weekday");
                        } else {
                          print("weekend");

                          setState(() {
                            priceData = AppData().priceDataWeekend;
                            isWeekDay = false;
                          });
                        }
                      });
                    },
                  ),
                  priceData.isEmpty
                      ? const SizedBox()
                      : Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 4.0, // gap between lines
                          children: <Widget>[
                            for (int index = 0; index < 14; index++)
                              FilterChip(
                                backgroundColor: !isTimeClick![index]
                                    ? Colors.white
                                    : Colors.green,
                                elevation: 5,
                                labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                label: Text(
                                  "${priceData[index]['time']}",
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ),
                                onSelected: (bool value) {
                                  print("resp : $value");
                                  print(
                                      "Data price : ${priceData[index]['price']}");
                                  print(
                                      "Data time :${priceData[index]['time']}");
                                  setState(() {
                                    isTimeClick![index] = !isTimeClick![index];
                                    totalPrice = 0;
                                    listWaktu.clear();
                                    for (int i = 0; i < priceData.length; i++) {
                                      if (isTimeClick![i]) {
                                        listWaktu.add(priceData[i]['time']);
                                        totalPrice +=
                                            int.parse(priceData[i]['price']);
                                      }
                                    }
                                  });
                                },
                              )
                          ],
                        ),
                  InkWell(
                    onTap: () async {
                      if (namaTeam.text.isNotEmpty &&
                          atasNama.text.isNotEmpty &&
                          noHp.text.isNotEmpty &&
                          lapangan.text.isNotEmpty &&
                          tglAwal.text.isNotEmpty &&
                          listWaktu.isNotEmpty) {
                        if (await isListJamSame(changeDateFormat(tglAwal.text),
                            isTimeClick!, lapangan.text)) {
                          saveDataToFirebase(
                              namaTeam.text,
                              atasNama.text,
                              lapangan.text,
                              totalPrice,
                              changeDateFormat(tglAwal.text),
                              isTimeClick!.toString());
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Pemesanan Berhasil"),
                                content:
                                    const Text("Lanjut ke Info Pembayaran !"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PaymentPage(
                                              noHp: noHp.text,
                                              atasName: atasNama.text,
                                              namaTeam: namaTeam.text,
                                              tanggalAwal: tglAwal.text,
                                              totalCost: totalPrice.toString(),
                                              lapangan: lapangan.text,
                                              listWaktu: listWaktu,
                                            ),
                                          ));
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Pemesanan Gagal"),
                                content: const Text(
                                    "Lapangan sudah di pesan di jam tersebut!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Untuk menutup AlertDialog
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pastikan data sudah lengkap!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 14,
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
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
