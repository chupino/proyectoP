
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class pdfViewers{
  Container pdfViewerBytes(Uint8List bytes){
    return Container(
      child: SfPdfViewer.memory(bytes),
    );
  }
}