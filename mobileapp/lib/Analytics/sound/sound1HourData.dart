import 'dart:convert';
import 'package:http/http.dart' as http;

class HourSoundData {
  final double x;
  final double y;

  HourSoundData({required this.x, required this.y});
}

Future<List<HourSoundData>> get1HourSoundData() async {
  final url = Uri.parse('https://uptimesensordata.000webhostapp.com/sound-1hour-data.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.asMap().entries.map((entry) => HourSoundData(x: entry.key.toDouble(), y: double.parse(entry.value.toString()))).toList();
  } else {
    throw Exception('Failed to fetch data from the PHP script');
  }
}