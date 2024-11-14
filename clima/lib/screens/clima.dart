import 'dart:convert';

import 'package:clima/model/tempoNow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClimaTempo extends StatefulWidget {
  @override
  State<ClimaTempo> createState() => _ClimaTempoState();
}

class _ClimaTempoState extends State<ClimaTempo> {
  fetchWeather() async {
    final response = await http.get(Uri.parse(
        "'https://api.openweathermap.org/data/2.5/weather?q=&appid=&units=metric&lang=pt_br';"));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      return WeatherData.fromJson(dados);
    } else {
      debugPrint("Conexão espirada");
    }
  }

  myWeather() {
    fetchWeather().then((value) {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 96, 146, 231),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {},
          child: Icon(Icons.menu),
        ),
        title: Text("Willi"),
        backgroundColor: Color.fromARGB(255, 96, 146, 231),
        foregroundColor: Colors.white,
      ),
      body: null,
    );
  }
}
