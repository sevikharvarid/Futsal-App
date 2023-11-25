import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ls_futsal/component/custom_app_bar.dart';
import 'package:ls_futsal/component/input_text_field.dart';

class DataLapanganPage extends StatefulWidget {
  @override
  State<DataLapanganPage> createState() => _DataLapanganPageState();
}

class _DataLapanganPageState extends State<DataLapanganPage> {
  TextEditingController stokBola = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  TextEditingController lapangan = TextEditingController();
  bool? isLoading = false;

  saveToFirebase({
    String? keterangan,
    String? stokBola,
    String? lapangan,
  }) {
    // Ambil referensi database
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    // Simpan data pemesanan ke database
    databaseRef.child('Data Lapangan').child(lapangan!).set({
      'keterangan': keterangan,
      'stokBola': stokBola,
    }).then((_) {
      setState(() {
        isLoading = false;
      });
      print('Data lapangan berhasil disimpan ke database');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Data lapangan berhasil disimpan ke database")));
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      print('Gagal menyimpan data lapangan ke database: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Input Data Lapangan",
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
              labelTitle: "Lapangan",
              controller: lapangan,
              hint: "Pilih lapangan",
              isVisible: false,
              isPassword: false,
              isDropDown: true,
              dropdownItems: const ['Lapangan 1', 'Lapangan 2', 'Lapangan 3'],
              onChangedDropdown: (selected) {
                setState(() {
                  print("selected item : $selected");
                });
                lapangan.text = selected;
              },
              onPressedSuffixIcon: () {},
            ),
            InputTextField(
              keyboardType: TextInputType.number,
              labelTitle: "Jumlah Stok Bola",
              controller: stokBola,
              hint: "0",
              isVisible: false,
              isPassword: false,
              onPressedSuffixIcon: () {},
            ),
            InputTextField(
              labelTitle: "Keterangan",
              controller: keterangan,
              hint: "Masukkan keterangan lapangan",
              isVisible: false,
              isPassword: false,
              onPressedSuffixIcon: () {},
            ),
            const SizedBox(
              height: 8,
            ),
            !isLoading!
                ? InkWell(
                    onTap: () {
                      if (keterangan.text.isNotEmpty &&
                          lapangan.text.isNotEmpty &&
                          stokBola.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        saveToFirebase(
                          keterangan: keterangan.text,
                          lapangan: lapangan.text,
                          stokBola: stokBola.text,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Harap isi data terlebih dahulu")));
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
