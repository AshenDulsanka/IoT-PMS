import 'dart:convert';
import 'package:http/http.dart' as http;

class Days10GasData {
  final double x;
  final double y;

  Days10GasData({required this.x, required this.y});
}

Future<List<Days10GasData>> get10DaysGasData() async {
  final url = Uri.parse('https://uptimesensordata.000webhostapp.com/gas-10day-data.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.asMap().entries.map((entry) => Days10GasData(x: entry.key.toDouble(), y: double.parse(entry.value.toString()))).toList();
  } else {
    throw Exception('Failed to fetch data from the PHP script');
  }
}