import 'dart:convert';
import 'dart:ui';

import 'package:encrypt/encrypt.dart' as cy;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:periodico/Widgets/Fwidgets.dart';
import 'package:periodico/Widgets/Widgets/fontChanger.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as pe;
import 'package:crypto/crypto.dart';
import 'package:textwrap/textwrap.dart';
import 'dart:math';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  double _fontSize = 19.099 / 1.618;
/*
  Future<void> _createPDF() async {
    var snackBarStart = const SnackBar(
      content: Text('Generando...'),
      duration: Duration(seconds: 1),
    );
    var snackBarFinal = const SnackBar(content: Text('Descargando'));
    var snackBarSFinal = const SnackBar(content: Text('Listo'));
    ScaffoldMessenger.of(context).showSnackBar(snackBarStart);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final index = args['index'] as int;
    final url = args['url'] as String;
    var data = await rootBundle.load("fonts/OpenSans-Regular.ttf");
    var myFont = pw.Font.ttf(data);
    var myStyleTitle = pw.TextStyle(font: myFont, fontSize: 25);
    var myStyleDesc = pw.TextStyle(font: myFont, fontSize: 20);
    var myStyleContent = pw.TextStyle(font: myFont, fontSize: 15);
    var myStyle = pw.TextStyle(font: myFont);
    print("INDEX DEL PDF: $index");
    //Map _news = await UserServices().getNew(index);
    Map _news = await UserServices().getArticle(url, index);

    final pdf = pw.Document();
    final image;
    _news["image"] != null
        ? image =
            await NetworkAssetBundle(Uri.parse(_news["image"] ?? "")).load('')
        : image = "";

    String prueba =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dictum non sem vel interdum. Maecenas bibendum nisi a elementum semper. Nunc id tellus a dolor ultricies dapibus non ac arcu. Nulla convallis odio sed venenatis porta. Mauris magna augue, molestie quis ipsum aliquam, pharetra laoreet massa. Quisque quis elit euismod, sagittis metus eu, porttitor justo. Fusce tempus arcu nisi, quis maximus erat hendrerit sit amet. Proin pulvinar pellentesque tellus ut suscipit. Cras non efficitur lorem. Aliquam sed volutpat turpis.Vivamus sed leo nec nibh convallis lacinia eu sed felis. Vestibulum id risus enim. Cras sed lacus ipsum. Integer leo erat, sagittis quis diam at, sodales suscipit ligula. Sed vel volutpat dui. Donec non lectus vel enim feugiat porta. Ut vitae augue a est semper vehicula at interdum sapien. Nam fermentum risus at imperdiet pretium. Praesent sit amet fermentum risus. Morbi sit amet faucibus massa, quis interdum tortor.Curabitur interdum euismod condimentum. Cras eget augue nunc. Quisque cursus varius purus, in convallis sem ultricies at. Donec ac scelerisque arcu, et facilisis libero. Nullam iaculis velit a ex ullamcorper, at gravida augue dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Sed vel lorem ac elit eleifend efficitur sit amet eget nunc. In eu nibh sed quam egestas condimentum.Curabitur tempor non mauris sed tincidunt. Etiam eu pellentesque nisl. Sed eget auctor dui, ac feugiat nisl. Maecenas aliquet convallis lorem, ac varius risus maximus vel. Nunc dapibus tortor turpis, sit amet auctor orci fringilla eget. Phasellus quis est varius, placerat ex nec, tristique nunc. Proin faucibus sodales tempus. Nulla luctus quis tellus vel rhoncus. Proin dignissim id nisi at ornare. Aenean tempor id nunc non tempor. Fusce sollicitudin ligula nec sollicitudin tincidunt. Sed sed malesuada libero.Aenean eu elementum lectus. Duis leo diam, sollicitudin quis urna viverra, auctor rhoncus velit. Phasellus sit amet vulputate sapien. Duis luctus orci nisl, eget venenatis leo fermentum rutrum. Duis cursus tincidunt hendrerit. Aliquam erat volutpat. Fusce risus mauris, egestas eget facilisis tincidunt, rhoncus sed ante. Integer laoreet risus sem, nec blandit urna convallis et. Fusce dolor dolor, scelerisque id elit at, gravida fringilla orci. Donec blandit pellentesque libero, ac finibus diam iaculis eget.In quam purus, luctus bibendum scelerisque non, interdum ac eros. Donec pharetra dui sit amet sem pellentesque sollicitudin. Nullam non tortor id ipsum consectetur sollicitudin non ac nisi. Suspendisse libero odio, efficitur ut eros et, varius vulputate odio. Fusce ante orci, ultrices vel tristique eu, facilisis a ligula. Quisque malesuada ex a turpis molestie pulvinar. Fusce id ligula ipsum. Proin tincidunt arcu eros. Mauris vehicula mi ligula, vel tempor arcu dictum ut. Cras luctus, libero in tempus sodales, ipsum nulla accumsan nunc, nec tincidunt orci massa ut mi. Vestibulum tincidunt nulla sit amet accumsan fringilla.Nunc sed mattis lectus. Nulla accumsan elit ut orci bibendum, scelerisque imperdiet ligula dignissim. Donec auctor aliquet tellus. Aliquam erat volutpat. Nunc ornare orci augue, ac efficitur purus interdum quis. Vestibulum eu massa vitae justo dignissim iaculis a quis purus. Morbi sagittis, nisl.";

    var wrapper = TextWrapper(width: PdfPageFormat.a4.width.round());
    List<String> lines = wrapper.wrap(_news["content"]);
    print(lines.length);
    List<pw.Widget> _myTextWidgets =
        lines.map((item) => pw.Text(item, style: myStyleContent)).toList();

    pdf.addPage(pw.MultiPage(
        maxPages: 200,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
              pw.Center(
                child: pw.Container(
                  width: double.infinity,
                  child: pw.Wrap(
                    runSpacing: 0,
                    children: [
                      pw.Row(children: [
                        _news["autor"] != ""
                        ?pw.Text(_news["autor"], style: myStyle)
                        :pw.Container(),
                        pw.SizedBox(width: 10),
                        pw.Text(_news["date"], style: myStyle)
                      ]),
                      pw.Text(_news["title"], style: myStyleTitle),
                      pw.SizedBox(height: 10),
                      pw.Text(_news["description"], style: myStyleDesc),
                      pw.SizedBox(height: 10),
                      image != ""
                          ? pw.Image(pw.MemoryImage(image.buffer.asUint8List()))
                          : pw.Container(),
                      ..._myTextWidgets
                    ],
                  ),
                ),
              ),
            ]));

    final output = await getApplicationDocumentsDirectory();
    final name = _news["title"];
    final file = File("${output.path}/${name}.pdf");
    await file.writeAsBytes(await pdf.save());
    print("PDF generado en ${file.path}");
    print(pdf.runtimeType);
    ScaffoldMessenger.of(context).showSnackBar(snackBarFinal);
    final key = cy.Key.fromUtf8('my 32 length keymy 32 length key');
    final iv = cy.IV.fromLength(16);
    final encrypter = cy.Encrypter(cy.AES(key));
    final pdfBytes = file.readAsBytesSync();
    final encrypted = encrypter.encryptBytes(pdfBytes, iv: iv);
    final encryptedFilePath = file.path;
    final encryptedFile = File(encryptedFilePath);
    encryptedFile.writeAsBytesSync(encrypted.bytes);

    ScaffoldMessenger.of(context).showSnackBar(snackBarSFinal);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Noticias"), actions: [
        IconButton(
            onPressed: () {
              _showFontSizePickerDialog();
            },
            icon: const Icon(
              Icons.format_size,
              size: 35,
            ))
      ]),
      body: NewDetails(),
    );
  }

  void _showFontSizePickerDialog() async {
    final selectedFontSize = await showDialog<double>(
      context: context,
      builder: (context) => Center(
        child: Column(
          children: [FontSizePickerDialog(initialFontSize: _fontSize)],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );

    if (selectedFontSize != null) {
      setState(() {
        _fontSize = selectedFontSize;
      });
    }
  }

  FutureBuilder NewDetails() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final index = args['index'] as int;
    final url = args['url'] as String;
    print("aa" + url);
    print("bb $index");
    print(UserServices().getArticle(url, index));
    return FutureBuilder(
              future: UserServices().getArticle(url, index),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        snapshot.data!["image"] != null
                            ? Image.network(snapshot.data!["image"])
                            : Container(),
                        snapshot.data!["date"] != null
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    snapshot.data!["autor"] != null
                                        ? Text(
                                            snapshot.data!["autor"],
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          )
                                        : Container(),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    snapshot.data!["date"] != null
                                        ? Text(
                                            snapshot.data!["date"],
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              )
                            : Container(),
                        snapshot.data!["title"] != null
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                child: Column(
                                  children: [
                                    Text(
                                      snapshot.data!["title"],
                                      style: const TextStyle(
                                          fontSize: 50 / 1.618,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Georgia"),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data!["description"],
                                      style: const TextStyle(
                                          fontSize: 30.902 / 1.618,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Georgia"),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(snapshot.data!["content"],
                                        style: TextStyle(
                                            fontSize: _fontSize,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Georgia"))
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          
      

  }
}
