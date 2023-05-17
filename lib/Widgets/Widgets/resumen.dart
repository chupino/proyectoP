import 'package:flutter/material.dart';

class resumenForm extends StatefulWidget {
  Map<String, dynamic> resumen;
  resumenForm({required this.resumen, super.key});

  @override
  State<resumenForm> createState() => _resumenFormState();
}

class _resumenFormState extends State<resumenForm> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> resumen = widget.resumen;
    return Scaffold(
      appBar: AppBar(
        title: Text('Boleta'),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.send))
        ],
      ),
      body: ListView.builder(
        itemCount: resumen.length,
        itemBuilder: (context, index) {
          final entry = resumen.entries.elementAt(index);
          final concepto = entry.key;
          final detalle = entry.value.toString();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                  title: Text(
                    concepto,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24, // Tamaño de letra personalizado
                    ),
                  ),
                  subtitle: Text(detalle,style: TextStyle(
                      fontSize: 18, // Tamaño de letra personalizado
                    ),),
                ),
                Divider(), // Línea separadora
              ],
            ),
          );
        },
      ),
    );
  }
}
