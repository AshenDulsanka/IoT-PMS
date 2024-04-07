import 'dart:convert';
import 'package:http/http.dart' as http;

class Days10VibData {
  final double x;
  final double y;

  Days10VibData({required this.x, required this.y});
}

Future<List<Days10VibData>> get10DaysVibData() async {
  final url = Uri.parse('https://uptimesensordata.000webhostapp.com/vib-10day-data.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.asMap().entries.map((entry) => Days10VibData(x: entry.key.toDouble(), y: double.parse(entry.value.toString()))).toList();
  } else {
    throw Exception('Failed to fetch data from the PHP script');
  }
}