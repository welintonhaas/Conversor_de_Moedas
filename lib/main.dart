import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

var url = Uri.https(
    'api.hgbrasil.com', '/finance', {'?': 'format=json&key=910e6206'});

     
const _cor = Colors.blueAccent;
const _fonte = 18.0;

void main() async {
  print(await buscaDados());
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> buscaDados() async {
  var response = await http.get(url);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realControl = TextEditingController();
  final dolarControl = TextEditingController();
  final euroControl = TextEditingController();
  final libraControl = TextEditingController();

  double real = 0;
  double dolar = 0;
  double euro = 0;
  double libra = 0;


  void _realChanged(String text) {
    double real = double.parse(text = text.isEmpty ? '0' : text);
    dolarControl.text = (real / dolar).toStringAsFixed(2);
    euroControl.text = (real / euro).toStringAsFixed(2);
    libraControl.text = (real / libra).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text = text.isEmpty ? '0' : text);
    realControl.text = (dolar * this.dolar).toStringAsFixed(2);
    euroControl.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    libraControl.text = (dolar * this.dolar / libra).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text = text.isEmpty ? '0' : text);
    realControl.text = (euro * this.euro).toStringAsFixed(2);
    dolarControl.text = (euro * this.euro / dolar).toStringAsFixed(2);
    libraControl.text = (euro * this.euro / libra).toStringAsFixed(2);
  }

  void _libraChanged(String text) {
    double euro = double.parse(text = text.isEmpty ? '0' : text);
    realControl.text = (libra * this.libra).toStringAsFixed(2);
    dolarControl.text = (libra * this.libra / dolar).toStringAsFixed(2);
    libraControl.text = (libra * this.libra).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: _cor,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: buscaDados(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: Text("Carregando Dados...",
                        style: TextStyle(color: _cor, fontSize: _fonte)));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao carregar os Dados...",
                    style: TextStyle(color: _cor, fontSize: _fonte),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.monetization_on, size: 150, color: _cor),
                        constroiCamposdeTexto(
                            "Reais", "R\$  ", realControl, _realChanged),
                        Divider(),
                        constroiCamposdeTexto(
                            "Dollares", "U\$  ", dolarControl, _dolarChanged),
                        Divider(),
                        constroiCamposdeTexto(
                            "Euro", "EUR€  ", euroControl, _euroChanged),
                        Divider(),
                        constroiCamposdeTexto(
                            "Libra", "£  ", libraControl, _libraChanged),
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(_cor),
                          ),
                          onPressed: () { 
                            _realChanged('0');
                            _dolarChanged('0');
                            _euroChanged('0');
                            _libraChanged('0');
                          },
                          child: Text('Limpar Valores'),
                        )
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget constroiCamposdeTexto(String label, String prefix,
    TextEditingController value, Function changed) {
  return TextField(
    controller: value,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _cor),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _cor, width: 0.0)),
        prefixText: prefix,
        prefixStyle: TextStyle(color: _cor, fontSize: _fonte)),
    style: TextStyle(color: _cor, fontSize: _fonte),
    onChanged: changed as void Function(String),
    keyboardType: TextInputType.number,
  );
}
