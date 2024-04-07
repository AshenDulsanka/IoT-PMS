import 'dart:convert';
import 'package:http/http.dart' as http;

class HourOilPressureData {
  final double x;
  final double y;

  HourOilPressureData({required this.x, required this.y});
}

Future<List<HourOilPressureData>> get1HourOilPressureData() async {
  final url = Uri.parse('https://uptimesensordata.000webhostapp.com/oilpressure-1hour-data.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.asMap().entries.map((entry) => HourOilPressureData(x: entry.key.toDouble(), y: double.parse(entry.value.toString()))).toList();
  } else {
    throw Exception('Failed to fetch data from the PHP script');
  }
}