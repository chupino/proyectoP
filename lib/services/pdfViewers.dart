
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as cy;
  
class pdfViewers{

  PdfViewerController controller=PdfViewerController();
  FutureBuilder pdfViewerBytes(){
    
    Future<Uint8List> pdfBytes () async{
      final prefs=await SharedPreferences.getInstance();
      final data=await prefs.getString("datosThumbnail")!;
      final dataDecode=json.decode(data);
      final fechaString=dataDecode["fecha"];
      print(fechaString);
      DateFormat format=DateFormat("dd-MM-yyyy");
      DateTime ahora=DateFormat("dd-MM-yyyy").parse(fechaString);
      String ahoraString=format.format(ahora);
      print(ahoraString);
      print(ahora);
      String url="https://diarioelpueblo.com.pe/wp-content/uploads/${ahora.year}/${ahora.month.toString().padLeft(2, '0')}/${ahoraString}.pdf";
      print("******************************$url");
    try{
      final response=await http.get(Uri.parse(url));
      Uint8List data=response.bodyBytes;
      print(data.runtimeType);
      return data;
    }catch(e){
      throw "error";
    }
  }
  void savePdf(BuildContext context)async{
    Uint8List bits=await pdfBytes();
    var snackBarStart = const SnackBar(content: Text('Descargando'));
    var snackBarFinal = const SnackBar(content: Text('Listo'));
    ScaffoldMessenger.of(context).showSnackBar(snackBarStart);
    DateTime now=DateTime.now();
    String dayName = DateFormat.EEEE("es").format(now);
    String monthName = DateFormat.MMMM("es").format(now);
    String formato ="$dayName ${now.day} de $monthName del ${now.year}";
    final output=await getApplicationDocumentsDirectory();
    final file=File("${output.path}/$formato.pdf");
    final key = cy.Key.fromUtf8('my 32 length keymy 32 length key');
    final iv = cy.IV.fromLength(16);
    final encrypter = cy.Encrypter(cy.AES(key));
    final encrypted = encrypter.encryptBytes(bits, iv: iv);
    final encryptedFilePath = file.path;
    final encryptedFile = File(encryptedFilePath);
    encryptedFile.writeAsBytesSync(encrypted.bytes);
    
    ScaffoldMessenger.of(context).showSnackBar(snackBarFinal);
  }
  return FutureBuilder(
    future: pdfBytes(),
    builder: (context,snapshot) {

    if(snapshot.hasData){
      return Scaffold(
      appBar: AppBar(
        title: Text("EDICION IMPRESA"),
        actions: [
        IconButton(onPressed: (){controller.zoomLevel=controller.zoomLevel+0.5;}, icon: Icon(Icons.zoom_in)),
        IconButton(onPressed: (){controller.zoomLevel=controller.zoomLevel-0.5;}, icon: Icon(Icons.zoom_out)),
        IconButton(onPressed: (){savePdf(context);}, icon: Icon(Icons.download))
      ]),
      body: SfPdfViewer.memory(
          snapshot.data!,
          controller: controller,),
    );
    }else{
      return CircularProgressIndicator(color: Theme.of(context).hoverColor,);
    }}
    
  );
  }
}