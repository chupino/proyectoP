import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as p;
import 'package:encrypt/encrypt.dart' as cy;

class PdfViewerW extends StatefulWidget {
  const PdfViewerW({super.key});

  @override
  State<PdfViewerW> createState() => _PdfViewerWState();
}

class _PdfViewerWState extends State<PdfViewerW> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    // TODO: implement initState
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final path = ModalRoute.of(context)!.settings.arguments as String;
    print("NUEVO $path");

    Future<Uint8List> _loadAndDecryptPDF() async {
      final key = cy.Key.fromUtf8('my 32 length keymy 32 length key');
      final iv = cy.IV.fromLength(16);
      final encrypter = cy.Encrypter(cy.AES(key));

      final encryptedData = await File(path).readAsBytes();
      final decryptedData =
          encrypter.decryptBytes(cy.Encrypted(encryptedData), iv: iv);

      return Uint8List.fromList(decryptedData);
    }


    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(p.basename(path)),
              actions: [
                IconButton(
                    onPressed: () {
                      _pdfViewerController.zoomLevel += 0.5;
                    },
                    icon: const Icon(Icons.zoom_in)),
                IconButton(
                    onPressed: () {
                      _pdfViewerController.zoomLevel -= 0.5;
                    },
                    icon: const Icon(Icons.zoom_out))
              ],
            ),
            body: FutureBuilder<Uint8List>(
              future: _loadAndDecryptPDF(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    //child: Text('Error: ${snapshot.error}'),
                    child: Text("Descifrado Incorrecto, compruebe la licencia"),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No se encontraron datos'),
                  );
                } else {
                  return SfPdfViewer.memory(
                    snapshot.data!,
                    controller: _pdfViewerController,
                  );
                }
              },
            )));

    /*SafeArea(
        child: Scaffold(
      body: path != null
          ? Container(child: SfPdfViewer.file(_file))
          : Center(
              child: CircularProgressIndicator(),
            ),
      appBar: AppBar(
        title: Text("PDF"),
      ),
    ));*/
  }
}
