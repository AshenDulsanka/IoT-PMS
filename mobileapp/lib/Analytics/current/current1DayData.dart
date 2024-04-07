import 'dart:convert';
import 'package:http/http.dart' as http;

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

Future<List<PricePoint>> getPricePoints() async {
  final url = Uri.parse('https://uptimesensordata.000webhostapp.com/current-1day-data.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.asMap().entries.map((entry) => PricePoint(x: entry.key.toDouble(), y: double.parse(entry.value.toString()))).toList();
  } else {
    throw Exception('Failed to fetch data from the PHP script');
  }
}