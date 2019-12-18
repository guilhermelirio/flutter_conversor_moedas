import 'package:conversor/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'utils/format.dart';

const API_URL = "https://api.hgbrasil.com/finance?format=json&key=6e96aa17";

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.amber,
      ),
    ),
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(API_URL);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  final Widget child;

  Home({Key key, this.child}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final pesoController = TextEditingController();
  final bitcoinController = TextEditingController();

  double dolar;
  double euro;
  double peso;
  double bitcoin;

  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = formatMoney2(double.tryParse((real/dolar).toStringAsFixed(2)), 'en_US');
    euroController.text = formatMoney2(double.tryParse((real/euro).toStringAsFixed(2)), 'en_GB');
    pesoController.text = formatMoney2(double.tryParse((real/peso).toStringAsFixed(2)), 'es_AR');
    bitcoinController.text = (real/bitcoin).toStringAsFixed(9);
  }

  void _dolarChanged(String text){
    double dolares = double.parse(text);
    realController.text = formatMoney2(double.tryParse((dolares * dolar).toStringAsFixed(2)), 'pt_BR');
    euroController.text = formatMoney2(double.tryParse((dolares * dolar / euro).toStringAsFixed(2)), 'en_GB');
    pesoController.text = formatMoney2(double.tryParse((dolares * dolar / peso).toStringAsFixed(2)), 'es_AR');
    bitcoinController.text = (dolares * dolar / bitcoin).toStringAsFixed(9);
  }

  void _euroChanged(String text){
    double euros = double.parse(text);
    realController.text = formatMoney2(double.tryParse((euros * euro).toStringAsFixed(2)), 'pt_BR');
    dolarController.text = formatMoney2(double.tryParse((euros * euro / dolar).toStringAsFixed(2)), 'en_US');
    pesoController.text = formatMoney2(double.tryParse((euros * euro / peso).toStringAsFixed(2)), 'es_AR');
    bitcoinController.text = (euros * euro / bitcoin).toStringAsFixed(9);
  }

  void _pesoChanged(String text){
    double pesos = double.parse(text);
    realController.text = formatMoney2(double.tryParse((pesos * peso).toStringAsFixed(2)), 'pt_BR');
    dolarController.text = formatMoney2(double.tryParse((pesos * peso / dolar).toStringAsFixed(2)), 'en_US');
    euroController.text = formatMoney2(double.tryParse((pesos * peso /euro).toStringAsFixed(2)), 'en_GB');
    bitcoinController.text = (pesos * peso / bitcoin).toStringAsFixed(9);
  }

  void _bitcoinChanged(String text){
    double bitcoins = double.parse(text);
    realController.text = formatMoney2(double.tryParse((bitcoins * bitcoin).toStringAsFixed(2)), 'pt_BR');
    dolarController.text = formatMoney2(double.tryParse((bitcoins * bitcoin / dolar).toStringAsFixed(2)), 'en_US');
    euroController.text = formatMoney2(double.tryParse((bitcoins * bitcoin / euro).toStringAsFixed(2)), 'en_GB');
    pesoController.text = formatMoney2(double.tryParse((bitcoins * bitcoin / peso).toStringAsFixed(2)), 'es_AR');
  }

  void _onClear() {
    realController.clear();
    dolarController.clear();
    euroController.clear();
    pesoController.clear();
    bitcoinController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados...", 
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0    
                  ),
                textAlign: TextAlign.center,
                ),
              );
            default:
            if(snapshot.hasError){
              return Center(
                child: Text("Erro ao carregar dados.", 
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0    
                  ),
                textAlign: TextAlign.center,
                ),
              );
              //Caso não tenha nenhum erro
            } else {
              //Captura o valor do dolar e do euro, e incrementa na variavel global.
              dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
              peso = snapshot.data["results"]["currencies"]["ARS"]["buy"];
              bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];

              return SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(Icons.monetization_on, size: 120.0, color: Colors.amber),
                    SizedBox(height: 20),
                    buildTextField("Reais", "R\$ ", realController, _realChanged, _onClear),
                    Divider(),
                    buildTextField("Dólares", "\$ ", dolarController, _dolarChanged, _onClear),
                    Divider(),
                    buildTextField("Euros", "€ ", euroController, _euroChanged, _onClear),
                    Divider(),
                    buildTextField("Peso Argentino", "\$ ", pesoController, _pesoChanged, _onClear),
                    Divider(),
                    buildTextField("Bitcoin", "\₿ ", bitcoinController, _bitcoinChanged, _onClear),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}