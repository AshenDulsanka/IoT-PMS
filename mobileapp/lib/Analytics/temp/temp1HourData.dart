import 'dart:convert';
import 'package:http/http.dart' as http;

class HourTempData {
  final double x;
  final double y;

  HourTempData({required this.x, required this.y});
}

Future<List<HourTempData>> get1HourTempData() async {
  final url = Uri.parse('https://uptimesensordata.000webhostapp.com/temp-1hour-data.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.asMap().entries.map((entry) => HourTempData(x: entry.key.toDouble(), y: double.parse(entry.value.toString()))).toList();
  } else {
    throw Exception('Failed to fetch data from the PHP script');
  }
}