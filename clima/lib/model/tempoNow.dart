class WeatherData {
  final String name;
  final Temperature temp;
  final int humidity;
  final Wind wind;
  final double temp_max;
  final double temp_min;
  final int pressure;
  final int sea_level;
  final int visibility;
  final List<WeatherInfo> weather;

  WeatherData({
    required this.name,
    required this.temp,
    required this.humidity,
    required this.wind,
    required this.temp_max,
    required this.temp_min,
    required this.pressure,
    required this.sea_level,
    required this.visibility,
    required this.weather,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      name: json['name'],
      temp: Temperature.fromJson(json['main']['temp']),
      humidity: json['main']['humidity'],
      wind: Wind.fromJson(json['wind']),
      temp_max: (json['main']['temp_max'] - 273.15),
      temp_min: (json['main']['temp_min'] - 273.15),
      pressure: json['main']['pressure'],
      sea_level: json['main']['sea_level'] ?? 0,
      visibility: (json['visibility'] ~/ 1000),
      weather: List<WeatherInfo>.from(
        json['weather'].map(
          (weather) => WeatherInfo.fromJson(weather),
        ),
      ),
    );
  }
}

class WeatherInfo {
  final String main;
  final String icon; 

  WeatherInfo({
    required this.main,
    required this.icon, 
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      main: json['description'],
      icon: json['icon'],
    );
  }
}

class Temperature {
  final double current;

  Temperature({required this.current});

  factory Temperature.fromJson(dynamic json) {
    return Temperature(
      current: (json - 273.15),
    );
  }
}

class Wind {
  final double speed;

  Wind({required this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(speed: json['speed']);
  }
}
