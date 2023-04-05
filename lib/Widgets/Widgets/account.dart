import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    final miControladorName = TextEditingController(text: "Nombre");
    final miControladorLastName = TextEditingController(text: "Apellido");
    final miControladorEmail = TextEditingController(text: "Email");
    final miControladorPass = TextEditingController(
      text: "Pass",
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Cuenta"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edita tus datos",
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorName,
                decoration: InputDecoration(
                  label: Text(
                    "Nombre",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorLastName,
                decoration: InputDecoration(
                  label: Text(
                    "Apellido",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorEmail,
                decoration: InputDecoration(
                  label: Text(
                    "Email",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorPass,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                    label: Text(
                      "Contraseña",
                      style: TextStyle(fontSize: 20),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                          print(_showPassword);
                        });
                      },
                    )),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Guardar"),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
