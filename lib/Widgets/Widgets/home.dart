

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:periodico/Widgets/Widgets/pdfViewer.dart';
import 'package:periodico/Widgets/Widgets/resumen.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:periodico/services/pdfViewers.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf_render/pdf_render.dart' as pr;
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as cy;


import '../../providers/ThemeHandler.dart';
import '../Fwidgets.dart';

class Home extends StatefulWidget {
  final List notas;
  final Uint8List imagenPDF;
  final String fecha;
  @override
  _HomePageState createState() => _HomePageState();

  Home({
    required this.notas,
    required this.imagenPDF,
    required this.fecha,
  });
}

class _HomePageState extends State<Home> with TickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>(); // Clave para validar el formulario
  int _currentStep = 0; // Variable para mantener el índice del paso actual
  String _name=""; // Variable para almacenar el nombre
  String _email=""; // Variable para almacenar el correo electrónico
  String _phone="";
  late TabController _tabController;
  int _selectedIndex = 0;
  late File documentPDF;
  bool inicioFormulario=true;
  String _selectedOption="Clasificados";
  
  double precioAnuncioFinal=0.0;
  int cantidaDePalabras=0;

  final TextEditingController _textController = TextEditingController();
  final tags=UserServices().tags;
  bool imagenValida=false;
  
  String _selectedOptionClasificados="1";
  String? _tipoAnuncio="Super-Economicos";
  String? _selectedProvince='Arequipa';
  String? _selectedCategory="Varios";
  String? _selectedDistrict="Cercado";
  var _selectedOptionEdictos="Edicto Matrimonial";
    List<String> _provinces = [
    'Arequipa',
    'Camaná',
    'Caravelí',
    'Caylloma',
    'Condesuyos',
    'Islay',
    'La Unión',
    'OTROS',
  ];

  Map<String,dynamic> boletaAnuncio={};
  List<String> _secciones=[
    "Economicos",
    "Super-Economicos"
  ];
  Map<String, List<String>> _districts = {
    'Arequipa': ["Cercado", "Alto Selva Alegre", "Cayma", "Cerro Colorado", "Characato", "Chiguata", "Jacobo Hunter", "La Joya", "Miraflorres", "Mollebaya", "Paucarpata", "Poso Alto", "Pozo Almonte", "Sabandía", "Sachaca", "San Juan de Siguas", "San Juan de Tarucani", "Santa Isabel de Siguas", "Santa Rita de Siguas", "Socabaya", "Tiabaya", "Uchumayo", "Vitor", "Yanahuara", "Yarabamba", "Yura"],
    'Camaná': ["Camaná", "José María Quimper", "Mariano Nicolás Valcárcel", "Mariscal Cáceres", "Nicolás de Pierola", "Ocoña", "Quilca", "Samuel Pastor"],
    'Caravelí':["Caravelí", "Acarí", "Atico", "Atiquipa", "Bella Unión", "Cahuacho", "Chaparra", "Huanuhuanu", "Jaqui", "Lomas", "Quicacha", "Yauca"],
    'Castilla':["Aplao", "Andagua", "Chachas", "Chilcaymarca", "Chuquibamba", "Viraco"],
    'Caylloma':['Chivay', 'Achoma', 'Cabanaconde', 'Callalli', 'Caylloma', 'Coporaque', 'Huambo', 'Huanca', 'Ichupampa', 'Lari', 'Lluta', 'Maca', 'Madrigal', 'San Antonio de Chuca', 'Sibayo', 'Tapay', 'Tisco', 'Tuti', 'Yanque'],
    'Condesuyos':["Chuquibamba", "Andaray", "Cayarani", "Chichas", "Iray", "Rio Grande", "Salamanca", "Yanaquihua"],
    'Islay':["Mollendo", "Cocachacra", "Dean Valdivia", "Islay", "Mejía", "Punta de Bombón"],
    'La Unión':["Cotahuasi", "Alca", "Charcana", "Huaynacotas", "Pampamarca", "Puyca", "Quechualla", "Sayla", "Tauria", "Tomepampa", "Toro"]
  };
  Map<String, List<String>> _categorias={
    "Economicos":[
    "Varios",
    "ALQUILER - Casas",
    "ALQUILER - Departamentos",
    "ALQUILER - Locales",
    "CASAS Y TERRENOS - Casas",
    "CASAS Y TERRENOS - Departamentos",
    "CASAS Y TERRENOS - Terrenos",
    "CASAS Y TERRENOS - Locales",
    "CASAS Y TERRENOS - Agricolas",
    "Construcciones",
    "Muebles",
    "Maquinas y equipos",
    "VEHICULOS - Automoviles",
    "VEHICULOS - Camionetas",
    "Pensiones",  
    "Valores",
    "Traspasos",
    "Empleos",
    "Oficios",
    "Domesticos",
    "Negocios",
    "Electrodomesticos",
    "Servicios"
],
    "Super-Economicos":[
    "Varios",
    "Alquiler",
    "Casas y Terrenos",
    "Construcciones",
    "Muebles",
    "Maquinas y equipos",
    "Vehiculos",
    "Pensiones",
    "Valores",
    "Traspasos",
    "Empleos",
    "Oficios",
    "Domesticos",
    "Negocios",
    "Electrodomesticos",
    "Servicios"
]
  };
  
  TextEditingController _date=TextEditingController();

  TextEditingController dateInicio=TextEditingController();
  TextEditingController dateFinal=TextEditingController();
  
  String? _selectedTipoCliente="1";
  
  String? _selectedComprobante="No Corresponde";

  var tipoAnuncio="Economicos";
  var tipoCliente="Persona Natural";
  var categoriaForm="";
  final tipoAnuncioForm=TextEditingController();
  final seccionAnuncioForm=TextEditingController();
  final ndiasForm=TextEditingController();
  final fechaForm=TextEditingController();
  final contenidoAnuncioForm=TextEditingController();
  final nombreForm=TextEditingController();
  final apellidoForm=TextEditingController();
  final dniForm=TextEditingController();
  final emailForm=TextEditingController();
  final phoneForm=TextEditingController();
  final razonSocialForm=TextEditingController();
  final rucForm=TextEditingController();
  final empresaPhoneForm=TextEditingController();
  final contenidoEdictoForm=TextEditingController(text: " Hago saber que:<br>Que Don: _________________, de __ años de edad, estado civil _______, profesión __________, natural de __________, de nacionalidad _________, vecino del distrito de ___________, con domicilio en __________, Provincia de ___________ y Departamento de _________, con DNI Nº _________, quiere contraer matrimonio civil con Doña: _________________, de __ años de edad, estado civil _________, de profesión _____________, de nacionalidad _____________, vecina del distrito de _____________, con domicilio en _____________, Provincia de _____________ y Departamento de _____________, con DNI Nº _____________. Las personas que conozcan que los pretendientes tiene algún impedimento, deben de comunicar a esta oficina. <br>[ - Municipalidad de ??? -] - [ Direccion de la municipalidad ] <br>[ - Mes - ] - 2023<br> [ Nombre del Alcade ]<br> ALCALDE ");
  DateTime? firstDate;
  String? diasArticulos="0";
  
  bool nextDate=false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlatFormState());
    _tabController = TabController(length: 4, vsync: this);
    
  }
  

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeHandler>(context);
    return DefaultTabController(
      
        length: 4,
        child: Scaffold(
          appBar: appBarLogo(context),
          drawer: drawerMenu(context),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              pageNews(theme),
              pageHeadline(),
              lastNews(),
              corresponsalPage(),
            ],
          ),
          bottomNavigationBar:  navBar(
            selectedIndex: 0,
            key: Key("0"),
          ),
        ));
  }
Container test(){
  return Container();
}
  Drawer drawerMenu(BuildContext context) {
    void _enviarPortal(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        
        Uri.parse(url),
        webViewConfiguration: WebViewConfiguration(enableJavaScript: true,enableDomStorage: true,headers: {"url":url}),
        mode: LaunchMode.externalApplication
        
        );
    } else {
      throw 'No se pudo abrir $url';
    }
  }
    return Drawer(
      // Aquí puedes agregar los elementos que quieras mostrar en el menú
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: 
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 35,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                  height: 35,
                  child: Image.asset(
                    "assets/logo_blanco.png",
                    fit: BoxFit.contain,
                    height: 50, // ajusta la altura de la imagen
                  ),
                ),
                  ],
                ),
                
                
              
            decoration: BoxDecoration(
              color: Theme.of(context).drawerTheme.shadowColor,
            ),
          ),
          
          for (var i = 0; i < tags.length; i++)
              ListTile(
                leading: Text(tags[i]["titulo"],style: TextStyle(fontSize: 20),),
                trailing: IconButton(icon: Icon(Icons.add),onPressed: (){_enviarPortal(tags[i]["goTo"]);}),
              )
        ],
      ),
    );
  }

  AppBar appBarLogo(BuildContext context) {
    
    return AppBar(
      iconTheme: IconThemeData(
          size: 40.0, color: Theme.of(context).colorScheme.onPrimary),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Image.asset(
              "assets/logo_blanco.png",
              fit: BoxFit.contain,
              height: 50, // ajusta la altura de la imagen
            ),
          ),
          
        ],
      ),
      bottom: TabBar(
        isScrollable: true,
        indicatorColor: Theme.of(context).primaryColorDark,
        onTap: (value) => setState(() {
          _selectedIndex = value;
        }),
        controller: _tabController,
        tabs: const [
          Tab(text: 'LO ÚLTIMO'),
          Tab(text: 'EDICIÓN DE HOY'),
          Tab(text: 'CONTRATAR ANUNCIO'),
          Tab(text: 'SE NUESTRO CORRESPONSAL'),
        ],
      ),
    );
  }

  Container pageHeadline() {
    return Container(
      child: Center(
        child: pdfViewers().pdfViewerBytes()
      ),
    );
  }

  void _enviarMensajeWhatsApp() async {
    final String telefono = '51961811703'; // Número de teléfono de destino
    final String mensaje = _textController.text; // Mensaje a enviar

    // El enlace de WhatsApp debe comenzar con "whatsapp://send?phone="
    final String url =
        'whatsapp://send?phone=$telefono&text=${Uri.encodeFull(mensaje)}';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'No se pudo lanzar $url';
    }
  }

  SingleChildScrollView corresponsalPage() {
    Color colorBoton=Theme.of(context).hoverColor;
    MaterialStateProperty<Color> materialColorBoton=MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if(states.contains(MaterialState.hovered)){
        return colorBoton.withOpacity(0.4);
      }
      if(states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)){
        return colorBoton.withOpacity(0.8);
      }
      return colorBoton;
    });
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Center(
          child: Column(
            children: [
              Text(
                "Sé un Corresponsal",
                style: TextStyle(
                  fontSize: 35,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Comparte información valiosa con otros miembros de la comunidad para hacerla más segura.",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 25,
              ),
              SingleChildScrollView(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Theme.of(context).iconTheme.color ?? Colors.black,
                      width: 2),
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                width: MediaQuery.of(context).size.width - 80,
                height: MediaQuery.of(context).size.height * 0.3,
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  maxLines: null,
                ),
              )),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    
                    onPressed: () {
                      if (_textController.text.trim().isNotEmpty) {
                        _enviarMensajeWhatsApp();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Escribe algo'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Enviar",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                      backgroundColor: materialColorBoton,
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                  ),
                  Flexible(
                      child: Image.asset(
                    "assets/sello.png",
                    fit: BoxFit.cover,
                    height: 80,
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget lastNews() {
    

    return inicioFormulario?inicioForm():formulario();
  }

  Form formulario(){
    Color colorBoton=Theme.of(context).hoverColor;
    Color colorBoton2=Theme.of(context).canvasColor;
    MaterialStateProperty<Color> materialColorBoton=MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if(states.contains(MaterialState.hovered)){
        return colorBoton.withOpacity(0.4);
      }
      if(states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)){
        return colorBoton.withOpacity(0.8);
      }
      return colorBoton;
    });
    MaterialStateProperty<Color> materialColorBoton2=MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if(states.contains(MaterialState.hovered)){
        return colorBoton2.withOpacity(0.4);
      }
      if(states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)){
        return colorBoton2.withOpacity(0.8);
      }
      return colorBoton2;
    });
    List<Widget> datosNatural=[
      DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Comprobante a emitir",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))
                      
                      ),
                    icon: Icon(Icons.newspaper),
                    value: _selectedComprobante,
                    items: const [
                      DropdownMenuItem(
                        value: "No Corresponde",
                        child: Text("No Corresponde")
                        ),
                      DropdownMenuItem(
                        value: "Boleta",
                        child: Text("Boleta")
                        ),
                      DropdownMenuItem(
                        value: "Factura",
                        child: Text("Factura")
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedComprobante=value;
                      });
                    },
                  )
      
    ];

    List<Widget> datosJuridica=[
      TextFormField(
                    keyboardType: TextInputType.text,
                    controller: razonSocialForm,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Razón Social',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      suffixIcon: Icon(Icons.social_distance)
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo obligatorio';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // Aquí puedes guardar el valor ingresado por el usuario
                    },
                  ),
      SizedBox(
                  height: 50,
                ),
      TextFormField(
        keyboardType: TextInputType.number,
                    controller: rucForm,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'RUC',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      suffixIcon: Icon(Icons.business)
                    ),
                    onChanged: (value){
                      if(value.length>11){
                        rucForm.text=value.substring(0,11);
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo Obligatorio';
                      }
                      if (value.length != 11) {
                        return 'El número debe tener exactamente 11 dígitos';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // Aquí puedes guardar el valor ingresado por el usuario
                    },
                  ),
      SizedBox(
                  height: 50,
                ),
      TextFormField( 
                    keyboardType: TextInputType.number,
                    controller: empresaPhoneForm,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Telefono de la Empresa',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      suffixIcon: Icon(Icons.phone)
                    ),
                    onChanged: (value){
                      empresaPhoneForm.text=value.substring(0,9);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo Obligatorio';
                      }
                      if(value.length!=9){
                        return "El número debe tener exactamente 9 dígitos";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // Aquí puedes guardar el valor ingresado por el usuario
                    },
                  ),
      SizedBox(
                  height: 50,
                ),
        DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Comprobante a emitir",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))
                      
                      ),
                    icon: Icon(Icons.newspaper),
                    value: _selectedComprobante,
                    items: const [
                      DropdownMenuItem(
                        value: "No Corresponde",
                        child: Text("No Corresponde")
                        ),
                      DropdownMenuItem(
                        value: "Boleta",
                        child: Text("Boleta")
                        ),
                      DropdownMenuItem(
                        value: "Factura",
                        child: Text("Factura")
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedComprobante=value;
                      });
                    },
                  )
    ];
    bool isDetailComplete(){
      if(_currentStep==0){
        return true;
      }else if(_currentStep==1){
        if(_selectedOption=="Clasificados"){
          if(ndiasForm.text.isEmpty || dateFinal.text.isEmpty || dateInicio.text.isEmpty || contenidoAnuncioForm.text.isEmpty ){
          return false;
        }else{
          return true;
        }
        }else{
          if(ndiasForm.text.isEmpty || dateFinal.text.isEmpty || dateInicio.text.isEmpty || contenidoEdictoForm.text.isEmpty ){
          return false;
        }else{
          return true;
        }
        }
        
      }else if(_currentStep==2){
        if(_selectedTipoCliente=="1"){
          if(nombreForm.text.isEmpty || apellidoForm.text.isEmpty || dniForm.text.isEmpty || emailForm.text.isEmpty || phoneForm.text.isEmpty || !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(emailForm.text) || dniForm.text.length!=8 || phoneForm.text.length!=9){

              return false;

          }else{
            return true;
          }
        }else if(_selectedTipoCliente=="2"){
          if(nombreForm.text.isEmpty || apellidoForm.text.isEmpty || dniForm.text.isEmpty || emailForm.text.isEmpty || phoneForm.text.isEmpty || !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(emailForm.text) || razonSocialForm.text.isEmpty || rucForm.text.isEmpty ||empresaPhoneForm.text.isEmpty || dniForm.text.length!=8 || phoneForm.text.length!=9 || rucForm.text.length!=11 || empresaPhoneForm.text.length!=9){
            return false;
          }else{
            return true;
          }
        }
      }
      return false;
    }
          Map<String,dynamic> contarPalabras(){
      bool validation=_formKey.currentState!.validate();
      if(ndiasForm.text.isEmpty || dateInicio.text.isEmpty || dateFinal.text.isEmpty || contenidoAnuncioForm.text.isEmpty){
        print("no valido");
        throw "Error mano";
      }
      else{
        
        
        String contenidoNeto=contenidoAnuncioForm.text;
        var excepciones=[];
        var diccionario = [
            'cel.', 'CO2', 'co2', 'c-', 'C-', 'c/', 'C/', 'T-', 'T/', 'T.', 't-', 't/', 't.', 'tel.', 'telf.', 'cm3', 'cm2', 'm3', 'mt3', 'km2', 'mt2', 'Sr.', 'Sres.', 'Sra.', 'sra.', 's/', 's/.', 'S/', 'S/.', '.pe', '.com', 'y/o', 'E.I.R.L', 'E.I.R.L.', 'S.R.L.', 'S.R.L.', 'S.A.', 'S.A', 'S.A.C', 'S.A.C', 'a.C.', 'a.m.', 'Admón.', 'Admvo.', 'Almte.', 'Art.', 'av.', 'Cía.', 'c/u', 'D. o Da.', 'D.ª', 'D. E. P.', 'D. F.', 'D.G.', 'd. J. C.', 'Dr. o Dra.', 'E. U.', 'ed.', 'ed. rev.', 'ej.', 'etc.', 'exm. o Exmo.', 'Gral. o Gral.', 'Ing.', 'Jr.', 'Lic.', 'Ltda.', 'Máx.', 'Mín.', 'N. de E.', 'N. de la R.', 'N.º', 'pág.', 'Pd.', 'Prof.', 'P. S.', 'p. ej.', 'p. m.', 'RAE', 'S.A.', 'S.R.L.', 'S.L.', 'Sr.', 'Sra.', 'Srita.', 'Stgo.', 'Ud.', 'Uds.', 'Vd.', 'Vds.', 'm2', 'km2', 'cm2', 'mm2', 'm2.', 'km2.', 'cm2.', 'mm2.', 'm.', 'km.', 'cm.', 'mm.', 'kg.', 'mg.', 'L.', 'mL.', 'Hz.', 'N.', 'Pa.', 'J.', 'W.', 'A.', 'V.', 'Ω.', 'min.', 'h.', 'd.'
        ];
        List<String> resultados = [];
        for(var i=0; i<diccionario.length; i++){
          var index=contenidoNeto.indexOf(diccionario[i]);
          print(index);
          if(index!=-1){
            excepciones.add(diccionario[i]);
          }
        }
        RegExp expresionRegular = RegExp(r'[+-]?\d+(\.\d+)?');
        Iterable<Match> numerosFlotantes = expresionRegular.allMatches(contenidoNeto);
        for (Match match in numerosFlotantes) {
          resultados.add(match.group(0)!);
        }

        String textoTrim=contenidoNeto.trim();

        List<String> palabras = textoTrim.split(' ');
        int cantidadPalabras = palabras.length;

        

        double precioxPalabra=0.0;
        double precioAnuncio=0.0;
        double precioMin=0.0;
        int diasAnuncio=int.parse(ndiasForm.text);

        if(tipoAnuncio=="Economicos"){
          precioxPalabra=0.7;
          if(cantidadPalabras<10){
            precioAnuncio=double.parse((10*precioxPalabra*diasAnuncio).toStringAsFixed(2));
            precioMin=precioxPalabra*10;
          }else{
            precioAnuncio=double.parse((cantidadPalabras*precioxPalabra*diasAnuncio).toStringAsFixed(2));
            precioMin=precioxPalabra*10;
          }
        }else{
          precioxPalabra=1;
          if(cantidadPalabras<10){
            precioAnuncio=double.parse((10*precioxPalabra*diasAnuncio).toStringAsFixed(2));
            precioMin=precioxPalabra*10;

          }else{
            precioAnuncio=double.parse((cantidadPalabras*precioxPalabra*diasAnuncio).toStringAsFixed(2));
            precioMin=precioxPalabra*10;
          }
        }
        Map<String,dynamic> datosEnviar={
          "palabras":cantidadPalabras,
          "precio":precioAnuncio,
          "costoPalabra":precioxPalabra,
          "minPrecio":precioMin,
          "verExcepciones":excepciones,
          "numerosFontados":resultados,
          "verTexto":textoTrim
        };
        print("Tipo Anuncio: $tipoAnuncio");
        print("Costo anuncio: $precioAnuncio");
        print("Cantidad Palabras: $cantidadPalabras");
        print("Numeros: $resultados");
        print("Caracteres filtrados: $excepciones");

        precioAnuncioFinal=precioAnuncio;
        cantidaDePalabras=cantidadPalabras;
        return datosEnviar;
      }

    }
    return Form(
        key: _formKey,
        child: Stepper(
          controlsBuilder: (context,ControlsDetails controls){
            if(_currentStep==0){

              return Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    Expanded(child: ElevatedButton(child: Text("Siguiente"),onPressed: (){controls.onStepContinue!();},style: ButtonStyle(backgroundColor: materialColorBoton)),),
                  ],
                ),
              );
            }
            if(_currentStep==1){
              if(_selectedOption=="Clasificados"){
                return Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Row(children: [
                              Expanded(child: ElevatedButton(child: Text("Siguiente"),onPressed: (){controls.onStepContinue!();},style: ButtonStyle(backgroundColor: materialColorBoton)),),
                              const SizedBox(width: 12,),
                              Expanded(child: ElevatedButton(child: Text("Atrás"),onPressed: (){controls.onStepCancel!();},style: ButtonStyle(backgroundColor: materialColorBoton2)),),
                            ]),

                          );
              }else{
                return Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Row(children: [
                              Expanded(child: ElevatedButton(child: Text("Siguiente"),onPressed: (){controls.onStepContinue!();},style: ButtonStyle(backgroundColor: materialColorBoton)),),
                              const SizedBox(width: 12,),
                              Expanded(child: ElevatedButton(child: Text("Atrás"),onPressed: (){controls.onStepCancel!();},style: ButtonStyle(backgroundColor: materialColorBoton2)),),
                            ]),

                          );
              }
              
            }
            if(_currentStep==2){
              return Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    Expanded(child: ElevatedButton(child: Text("Terminar"),onPressed: (){
                      controls.onStepContinue!();
                    },style: ButtonStyle(backgroundColor: materialColorBoton)),),
                    const SizedBox(width: 12,),
                    Expanded(child: ElevatedButton(child: Text("Atrás"),onPressed: (){controls.onStepCancel!();},style: ButtonStyle(backgroundColor: materialColorBoton2)),),
                  ],
                ),
              );
            }
            /*
            if(_currentStep==3){
              return Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Row(children: [
                              Expanded(child: ElevatedButton(child: Text("Enviar"),onPressed: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                  resumenForm(resumen: boletaAnuncio)
                                ));
                              },style: ButtonStyle(backgroundColor: materialColorBoton)),),
                              const SizedBox(width: 12,),
                              Expanded(child: ElevatedButton(child: Text("Atrás"),onPressed: (){controls.onStepCancel!();},style: ButtonStyle(backgroundColor: materialColorBoton2)),),
                            ]),
                          );
            }*/
            else{
              return Container();
            }
            
          },
          physics: ScrollPhysics(),
          currentStep: _currentStep,
          onStepTapped: (step){
            print(step);
          },
          onStepContinue: () {

            if(_currentStep==0){
              setState(() {
                  _currentStep += 1;
                  boletaAnuncio["Tipo Anuncio"]=_selectedOption.toString();
                });
            }
            else if(_currentStep==1){
              
              if(_selectedOption=="Clasificados"){
                contarPalabras();
                boletaAnuncio["Sección"]=tipoAnuncio.toString();
                boletaAnuncio["Sub Seccion"]=_selectedCategory.toString();
                boletaAnuncio["Numero de Dias"]=ndiasForm.text;
                boletaAnuncio["Fecha Inicio"]=dateInicio.text;
                boletaAnuncio["Fecha Fin"]=dateFinal.text;
                boletaAnuncio["Contenido"]=contenidoAnuncioForm.text;
                boletaAnuncio["Precio Total"]=precioAnuncioFinal;
                boletaAnuncio["Cantidad de Palabras"]=cantidaDePalabras;
                
                
                
                _formKey.currentState!.validate();
                bool isDetailValid=isDetailComplete();
                if(isDetailValid){
                  setState(() {
                    if (_currentStep < 2) {
                      
                      _currentStep += 1;
                    } else {
                            // Envía el formulario
                    }
                });
              }
              _formKey.currentState!.save();
              }else if(_selectedOption=="Edicto"){
                precioAnuncioFinal=20.5*int.parse(ndiasForm.text);
                boletaAnuncio["Tipo Edicto"]=_selectedOptionEdictos.toString();
                boletaAnuncio["Fecha Inicio"]=dateInicio.text;
                boletaAnuncio["Fecha Fin"]=dateFinal.text;
                boletaAnuncio["Numero de Dias"]=ndiasForm.text;
                boletaAnuncio["Provincia"]=_selectedProvince.toString();
                boletaAnuncio["Distrito"]=_selectedDistrict.toString();
                boletaAnuncio["Contenido"]=contenidoEdictoForm.text;
                boletaAnuncio["Precio Total"]=precioAnuncioFinal;
                _formKey.currentState!.validate();
                bool isDetailValid=isDetailComplete();
                print(isDetailValid);
                if(isDetailValid){
                  setState(() {
                    if (_currentStep < 2) {
                      
                      _currentStep += 1;
                    } else {
                            // Envía el formulario
                    }
                });
              }
              }
              
            }
            else if(_currentStep==2){
              if(tipoCliente=="Persona Natural"){
                boletaAnuncio["Nombre Cliente"]=nombreForm.text;
                boletaAnuncio["Apellido Cliente"]=apellidoForm.text;
                boletaAnuncio["DNI Cliente"]=dniForm.text;
                boletaAnuncio["Correo"]=emailForm.text;
                boletaAnuncio["Celular Cliente"]=phoneForm.text;
                boletaAnuncio["Tipo Cliente"]=tipoCliente.toString();
                boletaAnuncio["Comprobante"]=_selectedComprobante.toString();
                _formKey.currentState!.validate();
                bool isDetailValid=isDetailComplete();
                if(isDetailValid){
                  setState(() {
                    if (_currentStep <= 2) {
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                  resumenForm(resumen: boletaAnuncio)
                                ));
                      } else {
                              // Envía el formulario
                      }
                  });
                }
              }else{
                boletaAnuncio["Nombre Cliente"]=nombreForm.text;
                boletaAnuncio["Apellido Cliente"]=apellidoForm.text;
                boletaAnuncio["DNI Cliente"]=dniForm.text;
                boletaAnuncio["Correo"]=emailForm.text;
                boletaAnuncio["Celular Cliente"]=phoneForm.text;
                boletaAnuncio["Tipo Cliente"]=tipoCliente.toString();
                boletaAnuncio["Comprobante"]=_selectedComprobante.toString();
                boletaAnuncio["Razón Social"]=razonSocialForm.text;
                boletaAnuncio["RUC"]=rucForm.text;
                boletaAnuncio["Celular Empresa"]=empresaPhoneForm.text;
                _formKey.currentState!.validate();
                bool isDetailValid=isDetailComplete();
                if(isDetailValid){
                  setState(() {
                    if (_currentStep <= 2) {
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                  resumenForm(resumen: boletaAnuncio)
                                ));
                      } else {
                              // Envía el formulario
                      }
                  });
                }
              }
              
              
              
            }
            
          
            
          },
          type: StepperType.vertical,
          onStepCancel: () {
            if(_currentStep==0){
              
            }else if(_currentStep==1){
              if(_selectedOption=="Clasificados"){
                boletaAnuncio.remove("Sección");
                boletaAnuncio.remove("Sub Seccion");
                boletaAnuncio.remove("Numero de Dias");
                boletaAnuncio.remove("Fecha Inicio");
                boletaAnuncio.remove("Fecha Fin");
                boletaAnuncio.remove("Contenido");
                boletaAnuncio.remove("Precio Total");
                boletaAnuncio.remove("Cantidad de Palabras");

              }else if(_selectedOption=="Edicto"){
                boletaAnuncio.remove("Tipo Edicto");
                boletaAnuncio.remove("Fecha Inicio");
                boletaAnuncio.remove("Fecha Fin");
                boletaAnuncio.remove("Numero de Dias");
                boletaAnuncio.remove("Provincia");
                boletaAnuncio.remove("Distrito");
                boletaAnuncio.remove("Contenido");
              }
            }else if(_currentStep==2 || _currentStep==3){
              if(tipoCliente=="Persona Natural"){
                boletaAnuncio.remove("Nombre Cliente");
                boletaAnuncio.remove("Apellido Cliente");
                boletaAnuncio.remove("DNI Cliente");
                boletaAnuncio.remove("Correo");
                boletaAnuncio.remove("Celular Cliente");
                boletaAnuncio.remove("Tipo Cliente");
                boletaAnuncio.remove("Comprobante");
              }else{
                boletaAnuncio.remove("Nombre Cliente");
                boletaAnuncio.remove("Apellido Cliente");
                boletaAnuncio.remove("DNI Cliente");
                boletaAnuncio.remove("Correo");
                boletaAnuncio.remove("Celular Cliente");
                boletaAnuncio.remove("Tipo Cliente");
                boletaAnuncio.remove("Comprobante");
                boletaAnuncio.remove("Razón Social");
                boletaAnuncio.remove("RUC");
                boletaAnuncio.remove("Celular Empresa");
              }
            }
            setState(() {
              if (_currentStep > 0) {
                _currentStep -= 1;
              } else {
                // Cancela el formulario
              }
            });
          },
          
          steps: 
          stepsForm(datosNatural, datosJuridica),
        ),
      );
    
  }

  List<Step> stepsForm(List<Widget> datosNatural, List<Widget> datosJuridica) {
    return [
          Step(
            title: Text('Tipo Anuncio'),
            content: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  
                  decoration: 
                  InputDecoration(
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)
                    ),
                    labelText: "Tipo de Anuncio"
                  ),
                  icon: Icon(Icons.newspaper),
                  value: _selectedOption,
                  items: const [
                    DropdownMenuItem(

                      value: "Clasificados",
                      child: Text("Clasificados")
                      ),
                    DropdownMenuItem(
                      value: "Edicto",
                      child: Text("Edicto")
                      ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      _selectedOption=value!;

                    });
                  },
                )
                
              ],
            ),
          ),
      if (_selectedOption == "Clasificados")
        Step(
          title: Text('Datos Anuncio'),
          content: Column(
            children: [
              SizedBox(
                height: 20
              ),
              DropdownButtonFormField<String>(
                  
                  value: tipoAnuncio,
                  items: _secciones.map((seccion){
                    return DropdownMenuItem<String>(
                      value: seccion,
                      child: Text(seccion),
                      );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      tipoAnuncio=value!;
                      _selectedCategory=_categorias[tipoAnuncio]![0];
                    });
                  },
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Sección",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                if(tipoAnuncio!=null && tipoAnuncio!="")
                  DropdownButtonFormField<String>(
                    isExpanded: false,
                    value: _selectedCategory,
                    items: _categorias[tipoAnuncio]?.map((subcategoria) {
                      return DropdownMenuItem<String>(
                        value: subcategoria,
                        child: Container(
                          width: 150,
                          child: Text(subcategoria,overflow: TextOverflow.visible))
                        
                        );
                        
                        } 
                        ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory=value;
                        
                      });
                    },

                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Sub Categoria",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))
                    ),
                  ),
                
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  
                  readOnly: true,
                  controller: dateInicio,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Desde',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.edit_calendar_rounded),
                  ),
                  onChanged: (value){
                    setState(() {
                      _formKey.currentState!.validate();
                      dateInicio.text=value;
                    });
                  },
                  onTap: ()async{
                    
                    DateTime? pickedDate=await showDatePicker(
                      confirmText: "Aceptar",
                      cancelText: "Cancelar",
                      builder: (BuildContext context, Widget? child) {
                        return child!;
                      },
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime.now(), 
                      lastDate: DateTime(2035)
                      );
                    if(pickedDate!=null){
                      dateInicio.text=DateFormat("dd/MM/yyyy").format(pickedDate);
                      setState(() {
                        dateFinal.text="";
                        ndiasForm.text="";
                        nextDate=true;
                        firstDate=pickedDate;
                      });
                      
                      if(dateFinal.text!=null && dateFinal.text!="" && dateFinal.text.isNotEmpty){
                        
                        print("datefinal no es nulo");
                        print(dateFinal.text);
                        final DateFormat format = DateFormat('dd/MM/yyyy');
                        DateTime fechaInicio=format.parse(dateInicio.text);
                        DateTime fechaFinal=format.parse(dateFinal.text);
                        final diferencia=fechaFinal.difference(fechaInicio).inDays;
                        setState(() {
                          ndiasForm.text=diferencia.toString();
                          
                        });
                      }
                    }
                    
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo Obligatorio';
                    }
                    return null;
                    
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  enabled: nextDate,
                  readOnly: true,
                  controller: dateFinal,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Hasta',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.edit_calendar_rounded),
                  ),
                  onChanged: (value){
                    setState(() {
                      _formKey.currentState!.validate();
                    });
                  },
                  onTap: ()async{
                    
                    DateTime? pickedDate=await showDatePicker(
                      confirmText: "Aceptar",
                      cancelText: "Cancelar",
                      builder: (BuildContext context, Widget? child) {
                        return child!;
                      },
                      context: context, 
                      initialDate: firstDate!.add(Duration(days: 1)), 
                      firstDate: firstDate!.add(Duration(days: 1)), 
                      lastDate: DateTime(2035)
                      );
                    if(pickedDate!=null){
                      dateFinal.text=DateFormat("dd/MM/yyyy").format(pickedDate);
                      if(dateInicio.text!=null && dateInicio.text!="" && dateInicio.text.isNotEmpty){
                        print("dateinicio no es nulo");
                        print(dateInicio.text);
                        print(dateFinal.text);
                        final DateFormat format = DateFormat('dd/MM/yyyy');
                        DateTime fechaInicio=format.parse(dateInicio.text);
                        DateTime fechaFinal=format.parse(dateFinal.text);
                        final diferencia=fechaFinal.difference(fechaInicio).inDays;
                        setState(() {
                          ndiasForm.text=diferencia.toString();
                        });
                      }
                    }
                    
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo Obligatorio';
                    }
                    return null;
                    
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  readOnly: true,
                  controller: ndiasForm,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Número de días",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.calendar_today_rounded)

                  ),
                  keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value!.isEmpty || value==null) {
                      return 'Campo Obligatorio';
                    }
                    final n = int.tryParse(value);
                    if (n == null || n <= 0) {
                      return 'Ingresa un número entero positivo';
                    }
                    return null;
                  },
                  onChanged: (value){
                    setState(() {
                      dateInicio.text=value;
                      _formKey.currentState!.validate();
                    });
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: contenidoAnuncioForm,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.post_add_rounded),
                    labelText: 'Ingresa el contenido del anuncio',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onChanged: (value){
                    setState(() {
                      _formKey.currentState!.validate();
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo Obligatorio';
                    }
                    
                    return null;
                  },
                  onSaved: (value) {
                    // Aquí puedes guardar el valor ingresado por el usuario
                  },
                ),
                

            ],
          ),
        )
      else if (_selectedOption == "Edicto")
        Step(
          title: Text('Datos Anuncio'),
          content: Column(
            children: [
              Text("Precio de Edicto por día S/.20.5"),
              SizedBox(height: 50,),
              
              DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Tipo de Anuncio",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))
                    ),
                  value: _selectedOptionEdictos,
                  items: const [
                    DropdownMenuItem(
                      value: "Edicto Matrimonial",
                      child: Text("Edicto Matrimonial")
                      ),
                    DropdownMenuItem(
                      value: "Aviso Registral",
                      child: Text("Aviso Registral")
                      ),
                    DropdownMenuItem(
                      value: "Modificación Registral",
                      child: Text("Modificación Registral")
                      ),
                    DropdownMenuItem(
                      value: "Rectificacion Administrativa",
                      child: Text("Rectificacion Administrativa")
                      ),
                    DropdownMenuItem(
                      value: "Proclama Matrimonial",
                      child: Text("Proclama Matrimonial")
                      ),
                    DropdownMenuItem(
                      value: "Otros",
                      child: Text("Otros")
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionClasificados=value!;
                    });
                    if(_selectedOptionClasificados=="Edicto Matrimonial"){
                      
                      contenidoEdictoForm.text=" Hago saber que:<br>Que Don: _________________, de __ años de edad, estado civil _______, profesión __________, natural de __________, de nacionalidad _________, vecino del distrito de ___________, con domicilio en __________, Provincia de ___________ y Departamento de _________, con DNI Nº _________, quiere contraer matrimonio civil con Doña: _________________, de __ años de edad, estado civil _________, de profesión _____________, de nacionalidad _____________, vecina del distrito de _____________, con domicilio en _____________, Provincia de _____________ y Departamento de _____________, con DNI Nº _____________. Las personas que conozcan que los pretendientes tiene algún impedimento, deben de comunicar a esta oficina. <br>[ - Municipalidad de ??? -] - [ Direccion de la municipalidad ] <br>[ - Mes - ] - 2023<br> [ Nombre del Alcade ]<br> ALCALDE ";

                    }else if(_selectedOptionClasificados=="Aviso Registral"){
                      contenidoEdictoForm.text=" Ante la Oficina de Registro del Estado Civil de la Municipalidad Distrital de _________, provincia de ___________ y departamento de __________, ha presentado: Don, _____________ quien mediante expediente Administrativo N° _______, solicita Rectificación Administrativa de la partida de Nacimiento registrada en el folio _____ del año _____; consignando en la misma con error no atribuible al Registrador Civil de la Época; los nombres de la madre de la titular de la partida dice ______ siendo correcto los nombres _________, se rectifica en merito a la Directiva 415-GRC/032-RENIEC. QUIENES SE CONSIDEREN AFECTADOS POR LA RECTIFICACIÓN A EFECTUARSE, PODRÁN SOLICITAR OPOSICIÓN DENTRO DE LOS (____) QUINCE DÍAS SIGUIENTES A LA FECHA DE PUBLICACIÓN, PRESENTANDO PRUEBA INSTRUMENTAL; DE LO CONTRARIO SERÁ RECHAZADA LA OPOSICIÓN.<br> [__Distrito__], ___ de ______ 2023<br>[__Nombre del Jefe de Registro Civil__]<br>Jefe de Registro Civil ";

                    }else{
                      contenidoEdictoForm.text="Ingrese un contenido";
                    }
                  },
                ),
                SizedBox(
                height: 50,
              ),
              TextFormField(
                  readOnly: true,
                  controller: dateInicio,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Desde',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.edit_calendar_rounded),
                  ),
                  onChanged: (value){
                    setState(() {
                      _formKey.currentState!.validate();
                    });
                  },
                  onTap: ()async{
                    
                    DateTime? pickedDate=await showDatePicker(
                      confirmText: "Aceptar",
                      cancelText: "Cancelar",
                      builder: (BuildContext context, Widget? child) {
                        return child!;
                        
                      },
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime.now(), 
                      lastDate: DateTime(2035)
                      );
                    if(pickedDate!=null){
                      
                      dateInicio.text=DateFormat("dd/MM/yyyy").format(pickedDate);
                      setState(() {
                        ndiasForm.text="";
                        nextDate=true;
                        dateFinal.text="";
                        firstDate=pickedDate;
                      });
                      if(dateFinal.text!=null && dateFinal.text!="" && dateFinal.text.isNotEmpty){
                        
                        print("datefinal no es nulo");
                        print(dateFinal.text);
                        final DateFormat format = DateFormat('dd/MM/yyyy');
                        DateTime fechaInicio=format.parse(dateInicio.text);
                        DateTime fechaFinal=format.parse(dateFinal.text);
                        final diferencia=fechaFinal.difference(fechaInicio).inDays;
                        setState(() {
                          ndiasForm.text=diferencia.toString();
                        });
                      }
                    }
                    
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo Obligatorio';
                    }
                    return null;
                    
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  enabled: nextDate,
                  readOnly: true,
                  controller: dateFinal,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Hasta',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.edit_calendar_rounded),
                  ),
                  onChanged: (value){
                    setState(() {
                      _formKey.currentState!.validate();
                    });
                  },
                  onTap: ()async{
                    
                    DateTime? pickedDate=await showDatePicker(
                      confirmText: "Aceptar",
                      cancelText: "Cancelar",
                      builder: (BuildContext context, Widget? child) {
                        
                          return child!;
                        
                      },
                      context: context, 
                      initialDate: firstDate!.add(Duration(days: 1)), 
                      firstDate: firstDate!.add(Duration(days: 1)), 
                      lastDate: DateTime(2035)
                      );
                    if(pickedDate!=null){
                      dateFinal.text=DateFormat("dd/MM/yyyy").format(pickedDate);
                      if(dateInicio.text!=null && dateInicio.text!="" && dateInicio.text.isNotEmpty){
                        print("dateinicio no es nulo");
                        print(dateInicio.text);
                        print(dateFinal.text);
                        final DateFormat format = DateFormat('dd/MM/yyyy');
                        DateTime fechaInicio=format.parse(dateInicio.text);
                        DateTime fechaFinal=format.parse(dateFinal.text);
                        final diferencia=fechaFinal.difference(fechaInicio).inDays;
                        setState(() {
                          ndiasForm.text=diferencia.toString();
                        });
                      }
                    }
                    
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo Obligatorio';
                    }
                    return null;
                    
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  readOnly: true,
                  controller: ndiasForm,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Número de días",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.calendar_today_rounded)

                  ),
                  keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value!.isEmpty || value==null) {
                      return 'Campo Obligatorio';
                    }
                    final n = int.tryParse(value);
                    if (n == null || n <= 0) {
                      return 'Ingresa un número entero positivo';
                    }
                    return null;
                  },
                  onChanged: (value){
                    setState(() {
                      _formKey.currentState!.validate();
                    });
                  },
                ),
                SizedBox(
                height: 50,
              ),
                DropdownButtonFormField<String>(
                  value: _selectedProvince,
                  items: _provinces.map((province) {
                    return DropdownMenuItem<String>(
                      value: province,
                      child: Text(province),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProvince = value;
                      print(_selectedProvince);
                      _selectedDistrict=_districts[_selectedProvince]![0];
                    });
                  },
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Provincia',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                SizedBox(
                height: 50,
              ),
                if (_selectedProvince != null  && _selectedProvince!="OTROS" || _selectedProvince != ""  && _selectedProvince!="OTROS")
                  DropdownButtonFormField<String>(
                    value: _selectedDistrict,
                    
                    items: _districts[_selectedProvince]?.map((district) {
                      return DropdownMenuItem<String>(
                        value: district,
                        child: Text(district),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDistrict = value;
                      });
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Distrito',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: contenidoEdictoForm,
                  decoration: InputDecoration(
                    labelText: 'Ingrese el contenido',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.edit_document)
                  ),


                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo Obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Aquí puedes guardar el valor ingresado por el usuario
                  },
                ),
                

            ],
          ),
        ),
        Step(
          title: Text("Datos Personales"),
          content: Column(      
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                  keyboardType: TextInputType.name,
                  controller: nombreForm,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa un nombre',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.person),
                    

                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo Obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Aquí puedes guardar el valor ingresado por el usuario
                  },
                ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                  controller: apellidoForm,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa un apellido',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.person)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo Obligatorio';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Aquí puedes guardar el valor ingresado por el usuario
                  },
                ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: dniForm,
                  onChanged: (value){
                    if (value.length > 8) {
                      dniForm.text = value.substring(0, 8);
                    }
                  },
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa un DNI',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.perm_identity)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Debe ser un número entero';
                    }
                    if (value.length != 8) {
                      return 'El número debe tener exactamente 8 dígitos';
                    }
                    // Validación adicional según tus necesidades
                    return null;
                  },
                  onSaved: (value) {
                    
                  },
                ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailForm,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa un correo electronico',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.email)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                      return 'Dirección de correo electrónico no válida';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Aquí puedes guardar el valor ingresado por el usuario
                  },
                ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneForm,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa un Telefono',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.phone)
                  ),
                  onChanged: (value){
                    if (value.length > 9) {
                      phoneForm.text = value.substring(0, 9);
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    if (value.length != 9) {
                      return 'El número debe tener exactamente 9 dígitos';
                    }
                    // Validación adicional según tus necesidades
                    return null;
                  },
                  onSaved: (value) {
                    // Aquí puedes guardar el valor ingresado por el usuario
                  },
                ),
                SizedBox(
                height: 50,
              ),
                DropdownButtonFormField<String>(
                  value: _selectedTipoCliente,
                  items: const [
                    DropdownMenuItem(
                      child: Text("Persona Natural"),
                      value: "1",),
                    DropdownMenuItem(
                      child: Text("Persona Juridica"),
                      value: "2",)
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTipoCliente=value;
                      tipoCliente=value!;
                      value=="1"?tipoCliente="Persona Natural":tipoCliente="Persona Juridica";
                    });
                  },
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Tipo de Persona',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                SizedBox(
                height: 50,
              ),
                _selectedTipoCliente=="1"?
                  Column(children: datosNatural,):Column(children: datosJuridica,)
                  
            ],
          ),
        ),
        /*
        Step(title: Text("Confirmar"), content: 
          Expanded(
            child: ListView.builder(
                    itemCount: boletaAnuncio.length,
                    itemBuilder: (context, index) {
                      return Text("a");
                    }
            ),
          )
        )
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [

          DataTable(
            columns: [
              DataColumn(label: Text("CONCEPTO")),
              DataColumn(label: Text("DETALLE")),
            ], 
            rows: boletaAnuncio.entries
            .map(
              (entry) => DataRow(cells: <DataCell>[
                DataCell(Text(entry.key,overflow: TextOverflow.clip, softWrap: true,)),
                DataCell(Flexible(child: Text(entry.value.toString()))),
              ]
            ),
          ).toList(),
              )
        ],)*/
        ];
  }

  Widget inicioForm() {
    return Container(
width: double.infinity,
height: 200,
child: Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      textAlign: TextAlign.center,
      '¿Quieres dar a conocer algo?',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(height: 16),
    Image.asset(Provider.of<ThemeHandler>(context, listen: false).theme ==
                          ThemeHandler().myThemeDark?"assets/logo_sello_blanco.png":"assets/sello.png",height: 200,),
    SizedBox(height: 16),
    ElevatedButton(
      onPressed: () {
        setState(() {
          inicioFormulario=false;
        });
      },
      child: Text(
        
        'Publica un anuncio ya!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        padding: EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  ],
),
);
  }


Widget pageNews(ThemeHandler theme) {

    return SingleChildScrollView(
      child: Column(
        children: [
          miniatura(context),
          notas()
        ],
      
      
    ),
    );

}


Widget notas() {
  final List articulos=widget.notas as List;
  if(articulos.isNotEmpty){
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: articulos.length,
      itemBuilder: (context, index) {
        return Container(
                        child: Column(children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print(index);
                              Navigator.pushNamed(
                                context,
                                "/details",
                                arguments: {
                                  "index": index,
                                  "url": articulos[index]["url"]
                                },
                              );
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                width: MediaQuery.of(context).size.width - 20,
                                child: ListTile(
                                    title: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                      child: Text(
                                        articulos[index]["title"]??Container(),
                                        style: TextStyle(
                                            fontFamily: "Georgia",
                                            fontSize: 20),
                                      ),
                                    ),
                                    leading: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                      child: articulos[index]
                                                  ["image"] !=
                                              null && articulos[index]["image"] is String
                                          ? CachedNetworkImage(
                                            imageUrl: articulos[index]["image"],
                                            fit: BoxFit.cover,
                                            placeholder: (context,url)=>Container(color:Colors.black12),
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.black12,
                                              child: Icon(Icons.error,color: Colors.red,),
                                            ),
                                            )
                                          
                                          /*Image.network(
                                              articulos[index]
                                                  ["image"],
                                              fit: BoxFit.cover,
                                            )*/
                                          : const Icon(
                                              Icons.image,
                                              size: 50,
                                            ),
                                    ),
                                    subtitle: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: articulos[index]
                                                  ["autor"] !=
                                              null
                                          ? Text(articulos[index]
                                              ["autor"])
                                          : Text(""),
                                    ))),
                          ),
                        ]),
                      );
      },
    );
  }else{
    return Container(child: Text("No hay información"),);
  }
}
Widget articles() {
return FutureBuilder(
              future: UserServices().getTitles(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data!.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        child: Column(children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print(index);
                              Navigator.pushNamed(
                                context,
                                "/details",
                                arguments: {
                                  "index": index,
                                  "url": snapshot.data![index]["url"]
                                },
                              );
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                width: MediaQuery.of(context).size.width - 20,
                                child: ListTile(
                                    title: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                      child: Text(
                                        snapshot.data![index]["title"]??Container(),
                                        style: TextStyle(
                                            fontFamily: "Georgia",
                                            fontSize: 20),
                                      ),
                                    ),
                                    leading: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                      child: snapshot.data![index]
                                                  ["image"] !=
                                              null && snapshot.data![index]["image"] is String
                                          ? Image.network(
                                              snapshot.data![index]
                                                  ["image"],
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(
                                              Icons.image,
                                              size: 50,
                                            ),
                                    ),
                                    subtitle: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: snapshot.data![index]
                                                  ["autor"] !=
                                              null
                                          ? Text(snapshot.data![index]
                                              ["autor"])
                                          : Text(""),
                                    ))),
                          ),
                        ]),
                      );
                    }),
                  );
                } else {
                  return Center(child: CircularProgressIndicator(color: Colors.blue,));
                }
              }),
            );
          
  }

  Widget miniatura(BuildContext context){
    final Uint8List imagen=widget.imagenPDF;
    final fechaParametro=widget.fecha;

    if(imagen.isNotEmpty){
          return GestureDetector(
                            onTap: (() {
                              setState(() {
                                _tabController.animateTo(1);
                                _selectedIndex = 1;
                              });
                            }),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                border: Border(
                                  top: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: 
                                  Image.memory(imagen)
                                ,
                              ),
                            ),
                          );
        
        
        
      

    }else{
      return Container(
        child: Text("No se pudo cargar el pdf"),
      );
    }
  }
  FutureBuilder thumbnail(BuildContext context) {
    return FutureBuilder(
      future: UserServices().getThumbnail(),
      builder: (context,snapshot){
        if(snapshot.hasData){
            return GestureDetector(
                            onTap: (() {
                              DefaultTabController.of(context).index = 1;
                              setState(() {
                                _selectedIndex = 1;
          
                              });
                            }),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                border: Border(
                                  top: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: 
                                  Image.memory(snapshot.data!,fit: BoxFit.cover,)
                                ,
                              ),
                            ),
                          );
          
        }else{
          return SizedBox(
            height: 300,
            width: 300,
            child: Center(
              child: CircularProgressIndicator(),
            ),
            );
        }
        
      },
      
    );
  }

  Future<void> initPlatFormState() async {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      try {
        Map valoresNotifiacion = result.notification.additionalData!;
        String postId = valoresNotifiacion["post_id"].toString();
        Navigator.pushNamed(context, "/notification",
            arguments: {"postId": "$postId"});
        print("++++++++++++${result.notification.additionalData}");
      } catch (e) {
        print("Error en la notificación: $e");
      }
    });
  }
}
