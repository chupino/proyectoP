import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pdf/pdf.dart';

import '../Fwidgets.dart';
import 'package:path/path.dart' as p;

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  Future _getFiles() async {
    final Directory directory =
        Directory("/data/user/0/com.example.periodico/app_flutter");
    List<FileSystemEntity> files = await directory.list().toList();
    print(files.runtimeType);
    return files.where((file) => file.path.endsWith('.pdf')).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        tittle: "DESCARGAS",
      ),
      body: Center(
        child: FutureBuilder(
          future: _getFiles(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(p.basename(snapshot.data[index].path)),
                    leading: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                    ),
                    onTap: () {
                      print(snapshot.data[index].path);

                      Navigator.pushNamed(context, "/pdfViewer",
                          arguments: snapshot.data[index].path);
                    },
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      bottomNavigationBar: navBar(
        selectedIndex: 2,
        key: Key("2"),
      ),
    );
  }
}
