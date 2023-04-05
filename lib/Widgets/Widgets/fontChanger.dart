import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FontSizePickerDialog extends StatefulWidget {
  final double initialFontSize;

  const FontSizePickerDialog({Key? key, required this.initialFontSize})
      : super(key: key);

  @override
  _FontSizePickerDialogState createState() => _FontSizePickerDialogState();
}

class _FontSizePickerDialogState extends State<FontSizePickerDialog> {
  late double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      title: Text('Tamaño de Fuente'),
      content: Container(
        padding: EdgeInsets.zero,
        child: Slider(
          value: _fontSize,
          min: 19.099 / 1.618,
          max: 19.099,
          divisions: 2,
          onChanged: (value) {
            setState(() {
              _fontSize = value;
            });
          },
        ),
      ),
      actions: <Widget>[
        CupertinoButton(
          onPressed: () {
            Navigator.pop(context, _fontSize);
          },
          child: Text('LISTO'),
        )
      ],
    );
  }
}
