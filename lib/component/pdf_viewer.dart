import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportViewer extends StatefulWidget {
  final pw.Document report;
  const ReportViewer({
    Key? key,
    required this.report,
  });

  @override
  State<ReportViewer> createState() => _ReportViewerState();
}

class _ReportViewerState extends State<ReportViewer> {
  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      canChangeOrientation: false,
      canDebug: false,
      build: (format) => generateDocument(
        format,
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    var doc = pw.Document(pageMode: PdfPageMode.outlines);
    setState(() {
      doc = widget.report;
    });
    return doc.save();
  }
}
