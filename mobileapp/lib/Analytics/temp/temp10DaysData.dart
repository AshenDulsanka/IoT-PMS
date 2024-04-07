import 'dart:convert';
import 'package:http/http.dart' as http;

class Days10TempData {
  final double x;
  final double y;

  Days10TempData({required this.x, required this.y});
}

Future<List<Days10TempData>> get10DaysTempData() async {
  final url = Uri.parse('https://uptimesensordata.000webhostapp.com/temp-10day-data.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.asMap().entries.map((entry) => Days10TempData(x: entry.key.toDouble(), y: double.parse(entry.value.toString()))).toList();
  } else {
    throw Exception('Failed to fetch data from the PHP script');
  }
}