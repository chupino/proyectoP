import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/ThemeHandler.dart';
import '../services/dataHandler.dart';

class appBar extends StatelessWidget implements PreferredSizeWidget {
  final String tittle;
  const appBar({Key? key, required this.tittle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(tittle),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class navBar extends StatefulWidget {
  final int selectedIndex;
  const navBar({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  late int _selectedIndex;
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  void _setIndex(int value) {
    setState(() {
      _selectedIndex = value;
    });
    switch (value) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/downloads');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColorLight,
      
      type: BottomNavigationBarType.fixed,
      iconSize: 30,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Theme.of(context).primaryColorLight,
          ),
          label: "INICIO",

          activeIcon: IconWithBackground(icon: Icons.home, backgroundColor: Colors.red)
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.explore,
            color: Theme.of(context).primaryColorLight,
          ),
          label: "CATEGORIAS",
          activeIcon: IconWithBackground(icon: Icons.explore, backgroundColor: Colors.red)
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.library_books,
            color: Theme.of(context).primaryColorLight,
          ),
          label: "PERIODICOS",
          activeIcon: IconWithBackground(icon: Icons.library_books, backgroundColor: Colors.red)
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).primaryColorLight,
          ),
          label: "AJUSTES",
          activeIcon: IconWithBackground(icon: Icons.settings, backgroundColor: Colors.red)
        )
      ],
      currentIndex: _selectedIndex,
      onTap: _setIndex,
      unselectedLabelStyle: TextStyle(color: Colors.white),
      selectedLabelStyle: TextStyle(fontSize: 15),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final Text label;
  final IconData onIcon;
  final IconData offIcon;
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final String tag;
  final bool valueKey;

  const CustomSwitch({
    required this.label,
    required this.onIcon,
    required this.offIcon,
    required this.initialValue,
    required this.onChanged,
    required this.tag,
    required this.valueKey,
  });

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _value = false;
  bool isOkay = true;

  @override
  void initState() {
    _value = widget.initialValue;
    super.initState();
  }

  void _onTap() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Espera un momento...'),
        duration: Duration(seconds: 2),
      ),
    );

    if (widget.valueKey == true) {
      setState(() {
        UserServices().saveSwitchState(widget.tag, false);
      });
      try {
        await OneSignal.shared.sendTags({widget.tag: ""});
        print("aaa");
        // actualizar el estado del icono
      } catch (e) {
        print(e);
        isOkay = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No tienes internet'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          UserServices().saveSwitchState(widget.tag, false);
        });
        // mostrar un mensaje de error al usuario
        // no actualizar el estado del icono
      }
    } else {
      setState(() {
        UserServices().saveSwitchState(widget.tag, true);
      });
      try {
        await OneSignal.shared.sendTags({widget.tag: "true"});
        print("aaa");
        // actualizar el estado del icono
      } catch (e) {
        isOkay = false;
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No tienes internet'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          UserServices().saveSwitchState(widget.tag, true);
        });
        // mostrar un mensaje de error al usuario
        // no actualizar el estado del icono
      }
    }
    if (isOkay == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hecho'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _value = !_value;
        widget.onChanged(_value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: _onTap,
      title: widget.label,
      trailing: Icon(
        _value ? widget.onIcon : widget.offIcon,
        size: 30.0,
        color: _value ? Colors.green : Colors.red,
      ),
      /*child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: TextStyle(fontSize: 16.0),
            ),
            Icon(
              _value ? widget.onIcon : widget.offIcon,
              size: 30.0,
              color: _value ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),*/
    );
  }
}

class CustomCardTags extends StatefulWidget {
  
  final String title;
  final String image;
  final String url;

  const CustomCardTags({
    required this.title,
    required this.image,
    required this.url,
  });

  @override
  _CustomCardTagsState createState() => _CustomCardTagsState();
}

class _CustomCardTagsState extends State<CustomCardTags> {
  String title = "";
  String image = "";
  String url = "";

  @override
  void initState() {
    // TODO: implement initState
    title = widget.title;
    image = widget.image;
    url = widget.url;
    super.initState();
  }
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
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeHandler>(context);
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        _enviarPortal(url);
      },
      child: Card(
  
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 20,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        height: MediaQuery.of(context).size.height * 0.2-62,
                        width: MediaQuery.of(context).size.width / 2 - 60,
                        fit: BoxFit.fill,
                        
                        )
                    ),
                    Text(title,
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).scaffoldBackgroundColor
                        )),
                  ],
                ),
              ),
            ),
          ),
        
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;

  SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          hintText: 'Buscar...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              onSubmitted(controller.text);
              focusNode.unfocus();
            },
          ),
        ),
      ),
    );
  }
}

class IconWithBackground extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final double size;

  IconWithBackground({
    required this.icon,
    required this.backgroundColor,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
    );
  }
}

