import 'package:clima/database/dao/climadao.dart';
import 'package:clima/model/city.dart';
import 'package:clima/model/preview.dart';
import 'package:flutter/material.dart';
import 'package:clima/model/tempoNow.dart';
import 'package:clima/services/weather_services.dart';
import 'package:intl/intl.dart';

class ClimaTempo extends StatefulWidget {
  const ClimaTempo({super.key});

  @override
  State<ClimaTempo> createState() => _ClimaTempoState();
}

class _ClimaTempoState extends State<ClimaTempo> {
  WeatherData? weatherInfo;
  WeatherResponse? preview;
  bool isLoading = true;

  TextEditingController nameCity = TextEditingController();

  final Map<String, Map<String, dynamic>> weatherIcons = {
    '01d': {'icon': Icons.wb_sunny, 'color': Colors.yellow}, // Céu limpo - dia
    '01n': {
      'icon': Icons.nightlight_round,
      'color': Colors.blueGrey
    }, // Céu limpo - noite
    '02d': {
      'icon': Icons.cloud_sharp,
      'color': Colors.white
    }, // Poucas nuvens - dia
    '02n': {
      'icon': Icons.nights_stay_rounded,
      'color': Colors.indigo
    }, // Poucas nuvens - noite
    '03d': {
      'icon': Icons.cloud_queue_sharp,
      'color': Colors.grey
    }, // Nuvens dispersas - dia
    '03n': {
      'icon': Icons.cloud_queue_sharp,
      'color': Colors.blueGrey
    }, // Nuvens dispersas - noite
    '04d': {
      'icon': Icons.cloud,
      'color': Colors.grey
    }, // Nuvens quebradas - dia
    '04n': {
      'icon': Icons.cloud,
      'color': Colors.blueGrey
    }, // Nuvens quebradas - noite
    '09d': {'icon': Icons.grain, 'color': Colors.blue}, // Chuva leve - dia
    '09n': {'icon': Icons.grain, 'color': Colors.indigo}, // Chuva leve - noite
    '10d': {
      'icon': Icons.water_drop_outlined,
      'color': Colors.lightBlue
    }, // Chuva - dia
    '10n': {
      'icon': Icons.water_drop_rounded,
      'color': Colors.deepPurple
    }, // Chuva - noite
    '11d': {
      'icon': Icons.thunderstorm,
      'color': Colors.deepOrange
    }, // Trovoadas - dia
    '11n': {
      'icon': Icons.thunderstorm_outlined,
      'color': Colors.purple
    }, // Trovoadas - noite
    '13d': {
      'icon': Icons.ac_unit,
      'color': Colors.lightBlueAccent
    }, // Neve - dia
    '13n': {'icon': Icons.ac_unit, 'color': Colors.blueGrey}, // Neve - noite
    '50d': {'icon': Icons.foggy, 'color': Colors.grey}, // Névoa - dia
    '50n': {'icon': Icons.foggy, 'color': Colors.blueGrey}, // Névoa - noite
  };

  List dates = [];
  bool pass = true;
  myWeather(String city) async {
    try {
      WeatherData weather = await WeatherServices(city: city).fetchWeather();
      WeatherResponse forecastPreview =
          await WeatherServices(city: city).fetchPreview();
      setState(() {
        weatherInfo = weather;
        preview = forecastPreview;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Erro ao carregar os dados do tempo: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    myWeather('Tóquio');
  }

  Widget _drawerTile(String title, int id) {
    return ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.black,
          ),
          onPressed: () async {
            await deleteByID(id);
            setState(() {});
          },
        ),
        onTap: () async {
          List<Map<String, dynamic>> results = await selectData(title);
          if (results.isNotEmpty) {
            WeatherServices().city = results.first['city'];
            myWeather(results.first['city']);
          }
          Navigator.pop(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 91, 174, 212),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 91, 174, 212),
          foregroundColor: Colors.white,
          leading: Builder(
            builder: (context) {
              return weatherInfo != null
                  ? IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    )
                  : Container();
            },
          ),
          title: Text(weatherInfo?.name ?? ''),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : weatherInfo != null
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 80),
                            Icon(
                              weatherIcons[weatherInfo!.weather.first.icon]
                                  ?['icon'],
                              color:
                                  weatherIcons[weatherInfo!.weather.first.icon]
                                      ?['color'],
                              size: 120,
                            ),
                            Text(
                              '${(weatherInfo!.temp.current + 273).round()}º',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 70),
                            ),
                            Text(
                              weatherInfo!.weather.first.main,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            const SizedBox(height: 70),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildInfoCard("Minimum",
                                      '${(weatherInfo!.temp_min + 273).round()}°'),
                                  _buildInfoCard("Maximum",
                                      '${(weatherInfo!.temp_max + 273).round()}°'),
                                ],
                              ),
                            ),
                            SizedBox(height: 85),
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(165, 127, 204, 240),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(4, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0),
                                    child: _cardPreview(
                                      weatherIcons[preview!.list[index].weather
                                          .first.icon]?['icon'],
                                      weatherIcons[preview!.list[index].weather
                                          .first.icon]?['color'],
                                      35,
                                      '${((preview!.list[index].dtTxt).substring(11).toString())}',
                                      '${((preview!.list[index].main.temp).round().toString())}°',
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(165, 127, 204, 240),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    preview!.list.asMap().entries.map((entry) {
                                  var item = entry.value;
                                  String day = item.dtTxt.substring(0, 11);

                                  if (dates.isNotEmpty && dates.last == day) {
                                    return SizedBox();
                                  } else {
                                    DateFormat format =
                                        DateFormat('dd-MM-yyyy');
                                    DateTime dateTime = format.parse(day);
                                    DateFormat dayFormat = DateFormat('EEEE');
                                    String dia = "";

                                    if (pass) {
                                      dia = "Today";
                                      pass = false;
                                    } else {
                                      dia = dayFormat.format(dateTime);
                                    }

                                    dates.add(day);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      child: _cardWeek(
                                        weatherIcons[item.weather.first.icon]
                                            ?['icon'],
                                        weatherIcons[item.weather.first.icon]
                                            ?['color'],
                                        35,
                                        '${dia}',
                                        '${item.main.tempMin.round()}º    ${item.main.tempMax.round()}º',
                                      ),
                                    );
                                  }
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 50),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'indexes',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Divider(color: Colors.white),
                                  const SizedBox(height: 16),
                                  GridView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2.5,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                    children: [
                                      _buildCard(
                                          'humidity',
                                          '${(weatherInfo!.humidity)}%',
                                          Icons.water_drop),
                                      _buildCard(
                                          'Pressure',
                                          '${(weatherInfo!.pressure)} mb',
                                          Icons.speed),
                                      _buildCard(
                                          'Wind',
                                          '${(weatherInfo!.wind.speed)} km/h',
                                          Icons.air),
                                      _buildCard(
                                          'visibility',
                                          '${(weatherInfo!.visibility)} km',
                                          Icons.visibility),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Text(
                        'Erro ao carregar os dados do tempo',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
          ),
        ),
        drawer: Drawer(
          width: 10000,
          backgroundColor: Color.fromARGB(255, 91, 174, 212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: SingleChildScrollView(
            // Envolvendo a coluna com rolagem
            child: Column(
              children: [
                SizedBox(height: 80),
                // IconButton alinhado à direita
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o Drawer
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameCity,
                        decoration: InputDecoration(
                          labelText: 'Insira o local',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              insertCity(City(city: value));
                            });
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      FutureBuilder(
                        future: findall(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text("Erro ao carregar os dados."),
                              );
                            }

                            List<Map> dados = snapshot.data as List<Map>;

                            if (dados.isEmpty) {
                              return const Center(
                                child: Text(
                                  "Nenhuma cidade cadastrada.",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            return Column(
                              children: dados.map((item) {
                                return _drawerTile(item['city'], item['id']);
                              }).toList(),
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(165, 127, 204, 240),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(165, 127, 204, 240),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardPreview(
      IconData icon, Color cor, double x, String hora, String temp) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Icon(
            icon,
            color: cor,
            size: x,
          ),
          Text(hora,
              style: TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(124, 255, 255, 255),
              )),
          Text(temp,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    ));
  }

  Widget _cardWeek(
      IconData icon, Color cor, double x, String days, String temps) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: cor,
          size: x,
        ),
        title: Text(
          days,
          style: TextStyle(color: Colors.white),
        ),
        trailing:
            Text(temps, style: TextStyle(color: Colors.black, fontSize: 14)),
      ),
    );
  }
}
