import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ls_futsal/component/custom_app_bar.dart';
import 'package:ls_futsal/home/home_page_user.dart';
import 'package:ls_futsal/result/camera_page.dart';

class PaymentPage extends StatefulWidget {
  final String? atasName;
  final String? namaTeam;
  final String? noHp;
  final String? tanggalAwal;
  final String? totalCost;
  final String? lapangan;
  final List<dynamic>? listWaktu;
  const PaymentPage({
    Key? key,
    this.totalCost,
    this.lapangan,
    this.listWaktu,
    this.atasName,
    this.noHp,
    this.namaTeam,
    this.tanggalAwal,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? base64ImageData = "";
  static String imageToBase64(String imagePath) {
    File imageFile = File(imagePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  // Fungsi untuk mengambil gambar dari galeri
  void _getImageFromGallery() async {
    try {
      final XFile? picture =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (picture != null) {
        String imagePath = picture.path;
        String base64Image = imageToBase64(imagePath);
        print(base64Image);
        setState(() {
          base64ImageData = base64Image;
        });
        // Navigator.pop(context, base64Image);
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }

  void saveDataToFirebase(
    String tanggalAwal,
    String lapangan,
    String atasNama,
    String namaTeam,
    String listJam,
    int totalPrice,
    String image,
    String noHp,
  ) {
    // Ambil referensi database
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    User? user = FirebaseAuth.instance.currentUser;

    // Simpan data pemesanan ke database
    databaseRef.child('Data Pesanan').child(user!.uid).push().set({
      'Tgl': tanggalAwal,
      'Lapangan': lapangan,
      'Nama': atasNama,
      'Team': namaTeam,
      'Waktu': listJam,
      'Harga': totalPrice,
      'Image': image, // Kosongkan awalnya
      'isLunas': false, // Set awalnya ke false
      'Terbayar': 0, // Set awalnya ke 0
      'NoHp': noHp,
    }).then((_) {
      print('Data pemesanan berhasil disimpan ke database');
    }).catchError((error) {
      print('Gagal menyimpan data pemesanan ke database: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        title: "Pembayaran",
        backEnabled: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 5.5,
                  color: Colors.green,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 50,
                    horizontal: 16,
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Pemesanan",
                            style: TextStyle(),
                          ),
                          Text(
                            widget.lapangan!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Waktu Booking",
                            style: TextStyle(),
                          ),
                          Column(
                            children: [
                              for (int i = 0;
                                  i < widget.listWaktu!.length;
                                  i++) ...[
                                Text(
                                  "${widget.listWaktu![i]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Metode Pembayaran",
                            style: TextStyle(),
                          ),
                          Text(
                            "Transfer Bank/DANA",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "No. Rekening",
                            style: TextStyle(),
                          ),
                          Text(
                            "3216674890",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Upload bukti bayar",
                            style: TextStyle(),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CameraPage()),
                                  );
                                  if (result != null) {
                                    print('Path gambar: $result');
                                    setState(() {
                                      base64ImageData = result;
                                    });
                                  }
                                  // pickImage(camera: true);
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.green,
                                ),
                              ),
                              const Text("|"),
                              IconButton(
                                onPressed: () {
                                  // pickImage(camera: false);
                                  _getImageFromGallery();
                                },
                                icon: const Icon(
                                  Icons.photo,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                        child: Divider(),
                      ),
                      if (base64ImageData != "")
                        Row(
                          children: [
                            Container(
                              width:
                                  100, // Sesuaikan dengan ukuran gambar yang diinginkan
                              height: 100,
                              decoration: BoxDecoration(
                                // Atur decoration sesuai kebutuhan
                                shape: BoxShape
                                    .rectangle, // Ubah shape sesuai keinginan
                                image: DecorationImage(
                                  image: MemoryImage(
                                      base64.decode(base64ImageData!)),
                                  fit: BoxFit
                                      .cover, // Sesuaikan dengan kebutuhan (cover, contain, dll)
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  base64ImageData = "";
                                });
                              },
                              icon: const Icon(
                                Icons.delete_outline_outlined,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      InkWell(
                        onTap: () async {
                          if (base64ImageData != '') {
                            saveDataToFirebase(
                                widget.tanggalAwal!,
                                widget.lapangan!,
                                widget.atasName!,
                                widget.namaTeam!,
                                widget.listWaktu.toString(),
                                int.parse(widget.totalCost!),
                                base64ImageData!,
                                widget.noHp!);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePageUser()),
                              (route) =>
                                  false, // Menghapus semua rute sebelumnya
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Harap upload bukti bayar !")));
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 75),
              width: MediaQuery.of(context).size.width,
              height: 100,
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Rp. ${widget.totalCost}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Belum di bayar",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
