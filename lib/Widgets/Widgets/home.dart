

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
  String _selectedOption="1";
  
  final TextEditingController _textController = TextEditingController();
  final tags=UserServices().tags;
  bool imagenValida=false;
  
  String _selectedOptionClasificados="1";
  String? _selectedProvince='Arequipa';
  String? _selectedCategory="Varios";
  String? _selectedDistrict="Cercado";
  var _selectedOptionEdictos="1";
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
  
  String? _selectedTipoCliente="1";
  
  String? _selectedComprobante="1";

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
                        value: "1",
                        child: Text("No Corresponde")
                        ),
                      DropdownMenuItem(
                        value: "2",
                        child: Text("Boleta")
                        ),
                      DropdownMenuItem(
                        value: "3",
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
                    controller: razonSocialForm,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Razón Social',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      suffixIcon: Icon(Icons.social_distance)
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa una razón social';
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
                    controller: rucForm,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'RUC',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      suffixIcon: Icon(Icons.business)
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa un RUC';
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
                    controller: empresaPhoneForm,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Telefono de la Empresa',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      suffixIcon: Icon(Icons.phone)
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa un Telefono Valido';
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
                        value: "1",
                        child: Text("No Corresponde")
                        ),
                      DropdownMenuItem(
                        value: "2",
                        child: Text("Boleta")
                        ),
                      DropdownMenuItem(
                        value: "3",
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
        if(ndiasForm.text.isEmpty || _date.text.isEmpty || contenidoAnuncioForm.text.isEmpty){
          return false;
        }else{
          return true;
        }
      }else if(_currentStep==2){
        if(_selectedTipoCliente=="1"){
          if(nombreForm.text.isEmpty || apellidoForm.text.isEmpty || dniForm.text.isEmpty || emailForm.text.isEmpty || phoneForm.text.isEmpty){

              return false;

          }else{
            return true;
          }
        }else if(_selectedTipoCliente=="2"){
          if(nombreForm.text.isEmpty || apellidoForm.text.isEmpty || dniForm.text.isEmpty || emailForm.text.isEmpty || phoneForm.text.isEmpty || razonSocialForm.text.isEmpty || rucForm.text.isEmpty ||empresaPhoneForm.text.isEmpty){
            return false;
          }else{
            return true;
          }
        }
      }
      return false;
    }
    void contarPalabras(){
      bool validation=_formKey.currentState!.validate();
      if(ndiasForm.text.isEmpty || _date.text.isEmpty || contenidoAnuncioForm.text.isEmpty){
        print("no valido");
      }
      else{
        String contenidoNeto=contenidoAnuncioForm.text;
        var excepciones=[];
        var diccionario = [
            //Las abreviaturas las contaras primero
            'cel.', 'CO2', 'co2', 'c-', 'C-', 'c/', 'C/', 'T-', 'T/', 'T.', 't-', 't/', 't.', 'tel.', 'telf.', 'cm3', 'cm2', 'm3', 'mt3', 'km2', 'mt2', 'Sr.', 'Sres.', 'Sra.', 'sra.', 's/', 's/.', 'S/', 'S/.', '.pe', '.com', 'y/o', 'E.I.R.L', 'E.I.R.L.', 'S.R.L.', 'S.R.L.', 'S.A.', 'S.A', 'S.A.C', 'S.A.C', 'a.C.', 'a.m.', 'Admón.', 'Admvo.', 'Almte.', 'Art.', 'av.', 'Cía.', 'c/u', 'D. o Da.', 'D.ª', 'D. E. P.', 'D. F.', 'D.G.', 'd. J. C.', 'Dr. o Dra.', 'E. U.', 'ed.', 'ed. rev.', 'ej.', 'etc.', 'exm. o Exmo.', 'Gral. o Gral.', 'Ing.', 'Jr.', 'Lic.', 'Ltda.', 'Máx.', 'Mín.', 'N. de E.', 'N. de la R.', 'N.º', 'pág.', 'Pd.', 'Prof.', 'P. S.', 'p. ej.', 'p. m.', 'RAE', 'S.A.', 'S.R.L.', 'S.L.', 'Sr.', 'Sra.', 'Srita.', 'Stgo.', 'Ud.', 'Uds.', 'Vd.', 'Vds.', 'm2', 'km2', 'cm2', 'mm2', 'm2.', 'km2.', 'cm2.', 'mm2.', 'm.', 'km.', 'cm.', 'mm.', 'kg.', 'mg.', 'L.', 'mL.', 'Hz.', 'N.', 'Pa.', 'J.', 'W.', 'A.', 'V.', 'Ω.', 'min.', 'h.', 'd.'
        ];

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
              return Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Row(children: [
                              Expanded(child: ElevatedButton(child: Text("Siguiente"),onPressed: (){controls.onStepContinue!();},style: ButtonStyle(backgroundColor: materialColorBoton)),),
                              const SizedBox(width: 12,),
                              Expanded(child: ElevatedButton(child: Text("Atrás"),onPressed: (){controls.onStepCancel!();},style: ButtonStyle(backgroundColor: materialColorBoton2)),),
                              const SizedBox(width: 12,),
                              Expanded(child: ElevatedButton(child: Text("Calcular Precio"),onPressed: (){contarPalabras();},style: ButtonStyle(backgroundColor: materialColorBoton2)),),
                            ]),

                          );
            }
            if(_currentStep==2){
              return Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    Expanded(child: ElevatedButton(child: Text("Terminar"),onPressed: (){controls.onStepContinue!();},style: ButtonStyle(backgroundColor: materialColorBoton)),),
                    const SizedBox(width: 12,),
                    Expanded(child: ElevatedButton(child: Text("Atrás"),onPressed: (){controls.onStepCancel!();},style: ButtonStyle(backgroundColor: materialColorBoton2)),),
                  ],
                ),
              );
            }
            if(_currentStep==3){
              return Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Row(children: [
                              Expanded(child: ElevatedButton(child: Text("Enviar"),onPressed: (){controls.onStepContinue!();},style: ButtonStyle(backgroundColor: materialColorBoton)),),
                              const SizedBox(width: 12,),
                              Expanded(child: ElevatedButton(child: Text("Atrás"),onPressed: (){controls.onStepCancel!();},style: ButtonStyle(backgroundColor: materialColorBoton2)),),
                            ]),
                          );
            }
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
                });
            }
            else if(_currentStep==1){
              if(_selectedOption=="1"){
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
              }else if(_selectedOption=="2"){
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
              }
              
            }
            else if(_currentStep==2){

              _formKey.currentState!.validate();
              bool isDetailValid=isDetailComplete();
              if(isDetailValid){
                setState(() {
                  if (_currentStep <= 2) {
                    _currentStep += 1;
                    } else {
                            // Envía el formulario
                    }
                });
              }
              
            }
            
          
            
          },
          type: StepperType.vertical,
          onStepCancel: () {
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

                      value: "1",
                      child: Text("Clasificados")
                      ),
                    DropdownMenuItem(
                      value: "2",
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
      if (_selectedOption == "1")
        Step(
          title: Text('Datos Anuncio'),
          content: Column(
            children: [
              SizedBox(
                height: 20
              ),
              DropdownButtonFormField<String>(
                
                icon: Icon(Icons.attach_money),
                  decoration: const InputDecoration(
                    border:OutlineInputBorder(borderSide: BorderSide(width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    labelText: "Sección"
                    ),
                  value: _selectedOptionClasificados,
                  items: const [
                    DropdownMenuItem(
                      value: "1",
                      child: Text("Economicos")
                      ),
                    DropdownMenuItem(
                      value: "2",
                      child: Text("Super-Economicos")
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      value=="1"?tipoAnuncio="Economicos":tipoAnuncio="Super-Economicos";
                      _selectedOptionClasificados=value!;
                    });
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                DropdownButtonFormField<String>(
                
                icon: Icon(Icons.new_releases),
                  decoration: const InputDecoration(
                    border:OutlineInputBorder(borderSide: BorderSide(width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    labelText: "Sección"
                    ),
                  value: _selectedCategory,
                  items: _categorias[tipoAnuncio]?.map((subcategoria) {return DropdownMenuItem<String>(child: Text(subcategoria),value: subcategoria);} ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory=value;
                    });
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
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
                      return 'Ingresa un número entero positivo';
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
                TextFormField(
                  controller: _date,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa una fecha',
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
                        return Theme(
                          
                          data: ThemeData.light().copyWith(
                            canvasColor: Color(0xFF006414),
                            accentColor: Color(0xFF006414),
                            appBarTheme: AppBarTheme(backgroundColor: Color(0xFF006414),),
                            backgroundColor: Color(0xFF006414),
                            cardColor: Color(0xFF006414),
                            
                            textButtonTheme: TextButtonThemeData(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF006414)),
                                overlayColor: MaterialStateProperty.all<Color>(Color(0xFF006414)), 
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime(2000), 
                      lastDate: DateTime(2035)
                      );
                    if(pickedDate!=null){
                      _date.text=DateFormat("dd/MM/yyyy").format(pickedDate);
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa una fecha';
                    }
                    return null;
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
                      return 'Ingresa un contenido';
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
      else if (_selectedOption == "2")
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
                      value: "1",
                      child: Text("Edicto Matrimonial")
                      ),
                    DropdownMenuItem(
                      value: "2",
                      child: Text("Aviso Registral")
                      ),
                    DropdownMenuItem(
                      value: "3",
                      child: Text("Modificación Registral")
                      ),
                    DropdownMenuItem(
                      value: "4",
                      child: Text("Rectificacion Administrativa")
                      ),
                    DropdownMenuItem(
                      value: "5",
                      child: Text("Proclama Matrimonial")
                      ),
                    DropdownMenuItem(
                      value: "6",
                      child: Text("Otros")
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedOptionClasificados=value!;
                    });
                    if(_selectedOptionClasificados=="1"){
                      
                      contenidoEdictoForm.text=" Hago saber que:<br>Que Don: _________________, de __ años de edad, estado civil _______, profesión __________, natural de __________, de nacionalidad _________, vecino del distrito de ___________, con domicilio en __________, Provincia de ___________ y Departamento de _________, con DNI Nº _________, quiere contraer matrimonio civil con Doña: _________________, de __ años de edad, estado civil _________, de profesión _____________, de nacionalidad _____________, vecina del distrito de _____________, con domicilio en _____________, Provincia de _____________ y Departamento de _____________, con DNI Nº _____________. Las personas que conozcan que los pretendientes tiene algún impedimento, deben de comunicar a esta oficina. <br>[ - Municipalidad de ??? -] - [ Direccion de la municipalidad ] <br>[ - Mes - ] - 2023<br> [ Nombre del Alcade ]<br> ALCALDE ";

                    }else if(_selectedOptionClasificados=="2"){
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
                  controller: _date,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa una fecha',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.edit_calendar_rounded),
                  ),
                  
                  onTap: ()async{
                    DateTime? pickedDate=await showDatePicker(
                      confirmText: "Aceptar",
                      cancelText: "Cancelar",
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          
                          data: ThemeData.light().copyWith(
                            canvasColor: Color(0xFF006414),
                            accentColor: Color(0xFF006414),
                            appBarTheme: AppBarTheme(backgroundColor: Color(0xFF006414),),
                            backgroundColor: Color(0xFF006414),
                            cardColor: Color(0xFF006414),
                            
                            textButtonTheme: TextButtonThemeData(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF006414)),
                                overlayColor: MaterialStateProperty.all<Color>(Color(0xFF006414)), 
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime(2000), 
                      lastDate: DateTime(2035)
                      );
                    if(pickedDate!=null){
                      _date.text=DateFormat("dd/MM/yyyy").format(pickedDate);
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa una fecha válida';
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
                  
                  decoration: InputDecoration(
                    labelText: 'Ingresa un numero de dias',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.calendar_today_rounded)
                  ),
                  keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa un número entero positivo';
                    }
                    final n = int.tryParse(value);
                    if (n == null || n <= 0) {
                      return 'Ingresa un número entero positivo';
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
                      _selectedDistrict=null;
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
                      return 'Ingresa un contenido';
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
                  controller: nombreForm,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa un nombre',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.person),
                    

                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa nombre valido';
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
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa un apellido',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.person)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa apellido valido';
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
                  controller: dniForm,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa un DNI',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.perm_identity)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa dni valido';
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
                  controller: emailForm,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa un correo electronico',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.email)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa correo valido';
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
                  controller: phoneForm,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Ingresa un Telefono',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: Icon(Icons.phone)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa telefono valido';
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
        Step(title: Text("Confirmar"), content: Column(children: [
          Table(
            border: TableBorder.all(borderRadius: BorderRadius.circular(16)),
            children: [
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("CONCEPTO"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("DETALLE"),
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("Tipo Cliente"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(tipoCliente),
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("Tipo Anuncio"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(tipoAnuncio),
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("Categoria"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(_selectedCategory.toString()),
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("Detalles Anuncio"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(contenidoAnuncioForm.text??contenidoEdictoForm.text),
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("Cantidad de Dias"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(ndiasForm.text),
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("Precio total"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("S/."),
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("Cantidad de Palabras"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("n"),
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("Nombre del Cliente"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(nombreForm.text),
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("Apellido del Cliente"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(apellidoForm.text),
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("Telefono del Cliente"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(phoneForm.text),
                  )),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text("DNI del Cliente"),
                  )),
                  TableCell(child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(dniForm.text),
                  )),
                ]
              ),
            ],
          )
        ],))
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
