import 'package:flutter/material.dart';

class CustomCardViewHistory extends StatelessWidget {
  final String? lapangan;
  final String? nama;
  final String? team;
  final String? waktu;
  final String? tanggal;
  final String? image;
  final String? title;
  final bool? status;
  final int? nilaiTerbayar;
  const CustomCardViewHistory(
      {Key? key,
      this.image,
      this.title,
      this.lapangan,
      this.nama,
      this.team,
      this.waktu,
      this.tanggal,
      this.status,
      this.nilaiTerbayar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      // padding: const EdgeInsets.all(15),
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
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: Image.asset(
              image!,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title!,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(
            height: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Atas Nama : $nama",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    fontSize: 12),
              ),
              Text(
                "Tanggal : $tanggal",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    fontSize: 12),
              ),
              Text(
                "Waktu : $waktu",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    fontSize: 12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    nilaiTerbayar == 0
                        ? (!status!
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle)
                        : Icons.payment_outlined,
                    color: nilaiTerbayar == 0
                        ? (!status! ? Colors.red : Colors.green)
                        : Colors.amber,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    nilaiTerbayar == 0
                        ? (!status!
                            ? "Sedang di verifikasi"
                            : "Pemesanan berhasil")
                        : "DP Sebesar $nilaiTerbayar",
                    style: TextStyle(
                      fontSize: 12,
                      color: nilaiTerbayar == 0
                          ? (!status! ? Colors.red : Colors.green)
                          : Colors.amber,
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
