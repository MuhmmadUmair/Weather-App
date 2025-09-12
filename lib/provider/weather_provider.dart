import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherProvider with ChangeNotifier {
  WeatherProvider() {
    fetchWeather();
  }
  String _cityName = "Lahore";
  Map<String, dynamic>? _weather;
  bool _isLoading = false;
  String? _error;

  String get cityName => _cityName;
  Map<String, dynamic>? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeather([String? city]) async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    if (city != null && city.isNotEmpty) {
      _cityName = city;
    }

    try {
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$_cityName&APPID=$openWeatherApiKey",
        ),
      );

      final data = jsonDecode(res.body);
      if (data["cod"] != "200") throw "City not found!";

      _weather = data;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
