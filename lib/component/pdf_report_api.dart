import 'package:ls_futsal/data/lapangan_data.dart';
import 'package:ls_futsal/data/model_data.dart';
import 'package:ls_futsal/data/user_data.dart';
import 'package:ls_futsal/helper/general_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  Future<pw.Document> generate(
    String? reportTitle,
    List<PesananUser> pesananList,
    List<UserData> userList,
    List<DataLapangan> dataLapanganList,
    String dateTimeNow,
    int? type,
  ) async {
    try {
      final pdf = Document();

      pdf.addPage(MultiPage(
        build: (context) => [
          buildTitle(reportTitle), // Add the buildTitle only once
          buildPesanan(pesananList, userList, dataLapanganList, type),
          Divider(),
          buildInfo(dateTimeNow),
        ],
      ));
      return pdf;
    } catch (E) {
      throw Exception("Error is ini $E");
    }
  }

  static Widget buildTitle(String? reportTitle) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "LS Futsal",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
            reportTitle!,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
              "Jl. Alternatif Cicadas RT.03/RW.06, Cicadas, Gunung Putri, Tlajung Udik, Kec. Gn. Putri, "),
          Text("Kabupaten Bogor, Jawa Barat 16962"),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildPesanan(
      List<PesananUser> dataLaporan,
      List<UserData> userLaporan,
      List<DataLapangan> dataLapanganList,
      int? type) {
    if (type == 0) {
      final headers = [
        'Lapangan',
        'Harga',
        'Stok Bola',
        'Jadwal',
        'Keterangan'
      ];
      final data = PdfInvoiceApi()
          .getLapanganData(dataLapanganList)
          .map((pesanan) => [
                pesanan.lapangan,
                pesanan.hargaSewa,
                pesanan.stokBola,
                pesanan.jadwal,
                pesanan.keterangan,
              ])
          .toList();
      final headerRow = TableRow(
        children: headers.map((header) => buildHeaderCell(header)).toList(),
      );
      final dataRows = data.map((rowData) => TableRow(
            children:
                rowData.map((cellData) => buildDataCell(cellData!)).toList(),
          ));
      return Table(
        border: TableBorder.all(),
        children: [headerRow, ...dataRows],
      );
    } else if (type == 1) {
      final headers = [
        'Nama Pelanggan',
        'Email',
        'Alamat',
      ];
      final data = userLaporan
          .map((user) => [user.userName, user.email, user.alamat])
          .toList();
      final headerRow = TableRow(
        children: headers.map((header) => buildHeaderCell(header)).toList(),
      );
      final dataRows = data.map((rowData) => TableRow(
            children:
                rowData.map((cellData) => buildDataCell(cellData!)).toList(),
          ));
      return Table(
        border: TableBorder.all(),
        children: [headerRow, ...dataRows],
      );
    } else if (type == 2) {
      final headers = [
        'Tgl Pemesanan',
        'Nama Pelanggan',
        'No. HP',
        'Nama Team',
        'Lapangan',
        'Durasi Penyewaan'
      ];
      final data = dataLaporan
          .map((pesanan) => [
                pesanan.tanggal,
                pesanan.atasNama,
                pesanan.noHp.toString(),
                pesanan.namaTeam,
                pesanan.lapangan,
                '${GeneralHelper().calculateTotalHours(pesanan.waktu)} Jam'
              ])
          .toList();
      final headerRow = TableRow(
        children: headers.map((header) => buildHeaderCell(header)).toList(),
      );
      final dataRows = data.map((rowData) => TableRow(
            children:
                rowData.map((cellData) => buildDataCell(cellData)).toList(),
          ));
      return Table(
        border: TableBorder.all(),
        children: [headerRow, ...dataRows],
      );
    }
    final headers = [
      'Tgl',
      'Nama Team',
      'Lapangan',
      'Jml Pembayaran',
      'Atas Nama'
    ];
    final data = dataLaporan
        .map((pesanan) => [
              pesanan.tanggal,
              pesanan.namaTeam,
              pesanan.lapangan,
              pesanan.harga.toString(),
              pesanan.atasNama
            ])
        .toList();

    final headerRow = TableRow(
      children: headers.map((header) => buildHeaderCell(header)).toList(),
    );

    final dataRows = data.map((rowData) => TableRow(
          children: rowData.map((cellData) => buildDataCell(cellData)).toList(),
        ));

    return Table(
      border: TableBorder.all(),
      children: [headerRow, ...dataRows],
    );
  }

  static Widget buildInfo(String? dateTime) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10 * PdfPageFormat.mm),
                Text("$dateTime"),
                SizedBox(height: 12 * PdfPageFormat.mm),
                Divider(),
                Text("Ahmad Fauzi"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget buildDataCell(String text) {
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Text(text),
    );
  }

  List<DataLapangan> getLapanganData(List<DataLapangan>? datas) {
    List<DataLapangan> dataLapangan = [
      DataLapangan(
        lapangan: "Lapangan 1",
        hargaSewa: "100.000",
        jadwal: "Senin - jumat jam 8.00 s/d 15.00",
        stokBola: datas![0].stokBola,
        keterangan: datas[0].keterangan,
      ),
      DataLapangan(
        lapangan: "Lapangan 1",
        hargaSewa: "120.000",
        jadwal: "Senin - jumat jam 16.00 s/d 22.00",
        stokBola: datas[0].stokBola,
        keterangan: datas[0].keterangan,
      ),
      DataLapangan(
        lapangan: "Lapangan 1",
        hargaSewa: "150.000",
        jadwal: "Sabtu - Minggu",
        stokBola: datas[0].stokBola,
        keterangan: datas[0].keterangan,
      ),
      DataLapangan(
        lapangan: "Lapangan 2",
        hargaSewa: "100.000",
        jadwal: "Senin - jumat jam 8.00 s/d 15.00",
        stokBola: datas[1].stokBola,
        keterangan: datas[1].keterangan,
      ),
      DataLapangan(
        lapangan: "Lapangan 2",
        hargaSewa: "120.000",
        jadwal: "Senin - jumat jam 16.00 s/d 22.00",
        stokBola: datas[1].stokBola,
        keterangan: datas[1].keterangan,
      ),
      DataLapangan(
        lapangan: "Lapangan 2",
        hargaSewa: "150.000",
        jadwal: "Sabtu - Minggu",
        stokBola: datas[1].stokBola,
        keterangan: datas[1].keterangan,
      ),
      DataLapangan(
        lapangan: "Lapangan 3",
        hargaSewa: "100.000",
        jadwal: "Senin - jumat jam 8.00 s/d 15.00",
        stokBola: datas[2].stokBola,
        keterangan: datas[2].keterangan,
      ),
      DataLapangan(
        lapangan: "Lapangan 3",
        hargaSewa: "120.000",
        jadwal: "Senin - jumat jam 16.00 s/d 22.00",
        stokBola: datas[2].stokBola,
        keterangan: datas[2].keterangan,
      ),
      DataLapangan(
        lapangan: "Lapangan 3",
        hargaSewa: "150.000",
        jadwal: "Sabtu - Minggu",
        stokBola: datas[2].stokBola,
        keterangan: datas[2].keterangan,
      ),
    ];
    return dataLapangan;
  }
}
