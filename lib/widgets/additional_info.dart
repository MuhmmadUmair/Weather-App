import 'package:flutter/material.dart';
import 'package:weather_app/widgets/additional_info_item.dart';

class AdditionalInfoRow extends StatelessWidget {
  final String humidity;
  final String wind;
  final String pressure;

  const AdditionalInfoRow({
    super.key,
    required this.humidity,
    required this.wind,
    required this.pressure,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AdditionalInfoItem(
          icon: Icons.water_drop,
          label: "Humidity",
          value: "$humidity%",
        ),
        AdditionalInfoItem(icon: Icons.air, label: "Wind", value: "$wind m/s"),
        AdditionalInfoItem(
          icon: Icons.beach_access,
          label: "Pressure",
          value: "$pressure hPa",
        ),
      ],
    );
  }
}
