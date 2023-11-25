import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ls_futsal/component/custom_app_bar.dart';
import 'package:ls_futsal/component/number_input_dialog.dart';
import 'package:ls_futsal/home/home_page_admin.dart';

class DetailPageAdmin extends StatefulWidget {
  final String? atasName;
  final String? namaTeam;
  final String? tanggalAwal;
  final String? totalCost;
  final String? lapangan;
  final List<dynamic>? listWaktu;
  final String? buktiBayar;
  final String? userId;
  final String? keyId;
  const DetailPageAdmin(
      {Key? key,
      this.totalCost,
      this.lapangan,
      this.listWaktu,
      this.atasName,
      this.namaTeam,
      this.tanggalAwal,
      this.buktiBayar,
      this.userId,
      this.keyId});

  @override
  State<DetailPageAdmin> createState() => _DetailPageAdminState();
}

class _DetailPageAdminState extends State<DetailPageAdmin> {
  void changeStatus(bool? status, int? nilaiTerbayar) {
    // Ambil referensi database
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    // Simpan data pemesanan ke database
    databaseRef
        .child('Data Pesanan')
        .child(widget.userId!)
        .child(widget.keyId!)
        .update({
      'isLunas': status, // Set awalnya ke false
      'Terbayar': nilaiTerbayar ?? 0, // Set awalnya ke 0
    }).then((_) {
      print('Pembayaran berhasil, diterima !');
    }).catchError((error) {
      print('Gagal menyimpan data pemesanan ke database: $error');
    });
  }

  void showNumberInputDialog(BuildContext context) async {
    String? result = await showDialog(
      context: context,
      builder: (context) => const NumberInputDialog(),
    );

    if (result != null && result.isNotEmpty) {
      int jumlahUang = int.tryParse(result) ?? 0;
      changeStatus(false, jumlahUang);
      // Lakukan sesuatu dengan jumlahUang, misalnya simpan ke variabel atau kirim ke server
      print('Jumlah uang: Rp. $jumlahUang');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePageAdmin()),
        (route) => false, // Menghapus semua rute sebelumnya
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        title: "Detail Info User",
        backEnabled: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  // height: MediaQuery.of(context).size.height / 5.5,
                  color: Colors.green,
                  child: Image.asset(
                    widget.lapangan == 'Lapangan 1'
                        ? 'assets/images/lap1A.jpeg'
                        : widget.lapangan == 'Lapangan 2'
                            ? 'assets/images/lap2A.jpeg'
                            : 'assets/images/lap3A.jpeg',
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 90,
                    horizontal: 16,
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Atas Nama",
                            style: TextStyle(),
                          ),
                          Text(
                            widget.atasName!,
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
                            "Nama Team",
                            style: TextStyle(),
                          ),
                          Text(
                            widget.namaTeam!,
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
                            "Tanggal",
                            style: TextStyle(),
                          ),
                          Text(
                            widget.tanggalAwal!,
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
                        children: const [
                          Text(
                            "Bukti bayar",
                            style: TextStyle(),
                          ),
                          // Row(
                          //   children: [
                          //     IconButton(
                          //       onPressed: () async {
                          //         final result = await Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //                   const CameraPage()),
                          //         );
                          //         if (result != null) {
                          //           print('Path gambar: $result');
                          //           setState(() {
                          //             base64ImageData = result;
                          //           });
                          //         }
                          //         // pickImage(camera: true);
                          //       },
                          //       icon: const Icon(
                          //         Icons.camera_alt,
                          //         color: Colors.green,
                          //       ),
                          //     ),
                          //     const Text("|"),
                          //     IconButton(
                          //       onPressed: () {
                          //         // pickImage(camera: false);
                          //         _getImageFromGallery();
                          //       },
                          //       icon: const Icon(
                          //         Icons.photo,
                          //         color: Colors.green,
                          //       ),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                        child: Divider(),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showImageDialog(context, widget.buktiBayar!);
                            },
                            child: Container(
                              width:
                                  100, // Sesuaikan dengan ukuran gambar yang diinginkan
                              height: 100,
                              decoration: BoxDecoration(
                                // Atur decoration sesuai kebutuhan
                                shape: BoxShape
                                    .rectangle, // Ubah shape sesuai keinginan
                                image: DecorationImage(
                                  image: MemoryImage(
                                      base64.decode(widget.buktiBayar!)),
                                  fit: BoxFit
                                      .cover, // Sesuaikan dengan kebutuhan (cover, contain, dll)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          changeStatus(true, null);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePageAdmin()),
                            (route) => false, // Menghapus semua rute sebelumnya
                          );
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
                              "Lunas",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showNumberInputDialog(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 15,
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
                              "DP",
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
              margin: const EdgeInsets.only(left: 16, right: 16, top: 175),
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

  void showImageDialog(BuildContext context, String buktiBayar) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            // margin: const EdgeInsets.symmetric(horizontal: 16),
            // width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Hero(
                tag:
                    "imageHero", // Tag harus sama dengan tag di tampilan sebelumnya
                child: Image.memory(
                  base64.decode(buktiBayar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
