import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "Haroonabad";
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey",
        ),
      );
      final data = jsonDecode(res.body);
      if (data["cod"] != "200") {
        throw "An unexpected error occurred!";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final data = snapshot.data;
          final currentWeatherData = data?['list'][0];

          final currentTemp = (currentWeatherData["main"]["temp"] - 273.15)
              .toStringAsFixed(1);
          final currentSky = currentWeatherData["weather"][0]['main'];
          final currentPressure = currentWeatherData["main"]["pressure"];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    shadowColor: Colors.black.withOpacity(0.5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp°C",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky == 'Clouds'
                                    ? Icons.cloud
                                    : currentSky == 'Rain'
                                    ? Icons.cloudy_snowing
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data!['list'][index + 1];
                      final hourlySky = hourlyForecast['weather'][0]['main'];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                        icon:
                            hourlySky == 'Clouds'
                                ? Icons.cloud
                                : hourlySky == 'Rain'
                                ? Icons.cloudy_snowing
                                : Icons.sunny,
                        time: DateFormat.j().format(time),
                        temprature: (hourlyForecast['main']['temp'] - 273.15)
                            .toStringAsFixed(1),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
