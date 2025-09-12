import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/widgets/additional_info.dart';
import 'package:weather_app/widgets/current_weather_card.dart';
import 'package:weather_app/widgets/forecast_list.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  // Static helper so other widgets can use it
  static IconData getWeatherIconStatic(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.cloud_queue;
      case 'thunderstorm':
        return Icons.bolt;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.foggy;
      case 'clear':
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final typedCity = await showDialog<String>(
                context: context,
                builder: (context) {
                  final controller = TextEditingController(
                    text: provider.cityName,
                  );
                  return AlertDialog(
                    title: const Text("Enter City"),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "e.g. Karachi",
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed:
                            () =>
                                Navigator.pop(context, controller.text.trim()),
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
              if (typedCity != null && typedCity.isNotEmpty) {
                provider.fetchWeather(typedCity);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.fetchWeather(),
          ),
        ],
      ),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : provider.error != null
              ? Center(
                child: Text(
                  provider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : _buildContent(provider),
    );
  }

  Widget _buildContent(WeatherProvider provider) {
    final data = provider.weather!;
    final current = data['list'][0];
    final temp = (current['main']['temp'] - 273.15).toStringAsFixed(1);
    final sky = current['weather'][0]['main'];
    final humidity = current['main']['humidity'].toString();
    final pressure = current['main']['pressure'].toString();
    final wind = current['wind']['speed'].toString();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrentWeatherCard(condition: sky, temperature: temp),
          const SizedBox(height: 20),
          const Text(
            "Weather Forecast",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const ForecastList(),
          const SizedBox(height: 20),
          const Text(
            "Additional Information",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          AdditionalInfoRow(humidity: humidity, wind: wind, pressure: pressure),
        ],
      ),
    );
  }
}
