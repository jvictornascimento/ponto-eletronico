import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class MonthReportPdfPreviewPage extends StatelessWidget {
  const MonthReportPdfPreviewPage({
    super.key,
    required this.title,
    required this.bytes,
  });

  final String title;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PdfPreview(
        build: (format) => bytes,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
      ),
    );
  }
}
