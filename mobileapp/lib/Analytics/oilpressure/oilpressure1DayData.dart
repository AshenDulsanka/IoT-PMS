import 'dart:convert';
import 'package:http/http.dart' as http;

class DayOilPressureData {
  final double x;
  final double y;

  DayOilPressureData({required this.x, required this.y});
}

Future<List<DayOilPressureData>> get1DayOilPressureData() async {
  final url = Uri.parse('https://uptimesensordata.000webhostapp.com/oilpressure-1day-data.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.asMap().entries.map((entry) => DayOilPressureData(x: entry.key.toDouble(), y: double.parse(entry.value.toString()))).toList();
  } else {
    throw Exception('Failed to fetch data from the PHP script');
  }
}