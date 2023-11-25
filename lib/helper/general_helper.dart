// import 'dart:io';

// import 'package:open_file/open_file.dart';
// import 'package:pdf/widgets.dart';

// class PdfApi {
//   Future openFile(File file) async {
//     final url = file.path;

//     await OpenFile.open(url);
//   }

//   Future<File> saveDocument({
//     required String name,
//     required Document pdf,
//   }) async {
//     try {
//       final bytes = await pdf.save();

//       // final dir = await getApplicationDocumentsDirectory();
//       // final dir = await DownloadsPathProvider.downloadsDirectory;
//       // final file = File('${dir.path}/$name');
//       final file = File('/storage/emulated/0/Download/$name');

//       await file.writeAsBytes(bytes);
//       print("Try to Open File in $file");
//       // PermissionStatus status = await Permission.storage.request();
//       // if (status.isGranted) {
//       //   openFile(file);
//       // } else {
//       //   print("Status denied");
//       // }
//       print("Name Document : $name");
//       return file;
//     } catch (e) {
//       // Tangani error di sini
//       print('Error saving PDF: $e');
//       throw Exception('Error saving PDF: $e');
//     }
//   }
// }

class GeneralHelper {
  int calculateTotalHours(String timeString) {
    List<String> timeRanges =
        timeString.replaceAll('[', '').replaceAll(']', '').split(', ');

    int totalHours = 0;

    for (String range in timeRanges) {
      List<String> parts = range.split(' - ');

      if (parts.length == 2) {
        DateTime start = DateTime.parse('2023-08-18 ${parts[0]}:00');
        DateTime end = DateTime.parse('2023-08-18 ${parts[1]}:00');

        int diffInMinutes = end.difference(start).inMinutes;
        int hours = diffInMinutes ~/ 60;

        totalHours += hours;
      }
    }

    return totalHours;
  }
}
