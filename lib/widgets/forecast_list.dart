import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/screens/weather_screen.dart'; // for getWeatherIcon
import 'package:provider/provider.dart';
import 'package:weather_app/widgets/hourly_forecast_item.dart';

class ForecastList extends StatelessWidget {
  const ForecastList({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = context.watch<WeatherProvider>().weather!;
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, i) {
          final item = weather['list'][i + 1];
          final temp = (item['main']['temp'] - 273.15).toStringAsFixed(1);
          final sky = item['weather'][0]['main'];
          final time = DateTime.parse(item['dt_txt']);

          return HourlyForecastItem(
            icon: WeatherScreen.getWeatherIconStatic(sky),
            time: DateFormat.j().format(time),
            temprature: temp,
          );
        },
      ),
    );
  }
}
