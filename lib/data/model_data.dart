class Pesanan {
  String key;
  String tanggal;
  String lapangan;
  String atasNama;
  String namaTeam;
  String waktu;
  int harga;
  String buktiBayar;
  bool isLunas;
  int terbayar;

  Pesanan({
    required this.key,
    required this.tanggal,
    required this.lapangan,
    required this.atasNama,
    required this.namaTeam,
    required this.waktu,
    required this.harga,
    required this.buktiBayar,
    required this.isLunas,
    required this.terbayar,
  });
}

class PesananUser {
  String userId;
  String key;
  String tanggal;
  String lapangan;
  String atasNama;
  String namaTeam;
  String waktu;
  String noHp;
  int harga;
  String buktiBayar;
  bool isLunas;
  int terbayar;

  PesananUser({
    required this.userId,
    required this.key,
    required this.tanggal,
    required this.lapangan,
    required this.atasNama,
    required this.namaTeam,
    required this.waktu,
    required this.noHp,
    required this.harga,
    required this.buktiBayar,
    required this.isLunas,
    required this.terbayar,
  });
}
