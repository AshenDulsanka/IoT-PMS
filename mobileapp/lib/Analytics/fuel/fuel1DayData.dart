import 'dart:convert';
import 'package:http/http.dart' as http;

class DayFuelData {
  final double x;
  final double y;

  DayFuelData({required this.x, required this.y});
}

Future<List<DayFuelData>> get1DayCurrentData() async {
  final url = Uri.parse('https://uptimesensordata.000webhostapp.com/fuel-1day-data.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.asMap().entries.map((entry) => DayFuelData(x: entry.key.toDouble(), y: double.parse(entry.value.toString()))).toList();
  } else {
    throw Exception('Failed to fetch data from the PHP script');
  }
}