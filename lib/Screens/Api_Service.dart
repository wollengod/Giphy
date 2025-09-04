import 'dart:convert';
import 'package:http/http.dart' as http;

class GiphyApi {
  static const String _baseUrl = "https://api.giphy.com/v1/gifs";
  static const String _apiKey = "oHxfIlRkOEk76VGNhF4lhpH834RILHfk"; // My API key

  static Future<List<dynamic>> fetchTrending(int offset) async {
    final url =
        "$_baseUrl/trending?api_key=$_apiKey&limit=20&offset=$offset";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return json.decode(res.body)["data"];
    } else {
      throw Exception("Failed to load trending GIFs");
    }
  }

  static Future<List<dynamic>> searchGifs(String query, int offset) async {
    final url =
        "$_baseUrl/search?api_key=$_apiKey&q=$query&limit=20&offset=$offset";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return json.decode(res.body)["data"];
    } else {
      throw Exception("Failed to load search GIFs");
    }
  }
}
