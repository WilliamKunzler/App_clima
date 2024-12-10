import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:clima/model/tempoNow.dart';
import 'package:clima/model/preview.dart';

class WeatherServices {
  String? city = '';

  WeatherServices({this.city = 'Tóquio'});

  final String baseUrl = 'https://api.openweathermap.org/data/2.5';
  final String apiKey = '';  // adicione aqui sua chave da API

  Future<WeatherData> fetchWeather() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/weather?q=$city&appid=$apiKey&units=metric&lang=pt_br'));

    if (response.statusCode == 200) {
      var dados = jsonDecode(response.body);
      return WeatherData.fromJson(dados);
    } else {
      throw Exception("Falha ao buscar dados do tempo!");
    }
  }

  Future<WeatherResponse> fetchPreview() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/forecast?q=$city&appid=$apiKey&units=metric&lang=pt_br'));

    if (response.statusCode == 200) {
      var dados = jsonDecode(response.body);
      return WeatherResponse.fromJson(dados);
    } else {
      throw Exception("Falha ao buscar dados da previsão do tempo!");
    }
  }
}
