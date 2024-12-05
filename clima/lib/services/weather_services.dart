import 'dart:convert';
import 'package:clima/model/preview.dart';
import 'package:http/http.dart' as http;
import 'package:clima/model/tempoNow.dart';

class WeatherServices {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';
  final String apiKey = '';
  final String city = 'Lisboa';

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
