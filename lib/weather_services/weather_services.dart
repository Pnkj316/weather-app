import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:weather_app/model/weather_model.dart';

class WeatherServices {
  Future<WeatherData> fetchWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=49b45709cf5fda2bb5cb584e70c123ba"),
    );
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load Weather data');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}

class WeatherProvider extends ChangeNotifier {
  WeatherData? _weatherData;
  bool _isLoading = false;

  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;

  Future<void> fetchWeather(double lat, double lon) async {
    _isLoading = true;
    notifyListeners();

    try {
      _weatherData = await WeatherServices().fetchWeather(lat, lon);
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
