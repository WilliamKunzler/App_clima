class City {
  final String city;

  City({required this.city});

  Map<String, Object?> toMap() {
    return {'city': city};
  }

  @override
  String toString() {
    return 'Clima {city: $city}';
  }
}
