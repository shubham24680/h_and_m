import 'dart:convert';

import 'package:http/http.dart' as http;

class RapidApi {
  // Use the X-RapidAPI-Host to form the base URL
  static const String baseUrl =
      "https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com";

  // Add the headers, including the Host and API Key
  static const Map<String, String> headers = {
    "X-Rapidapi-Key": "e5a57f9031msh520d561c8b2e542p1cbb20jsn4dc99951f058",
    "X-Rapidapi-Host": "apidojo-hm-hennes-mauritz-v1.p.rapidapi.com",
  };

  // fetch the products from Rapid
  Future<dynamic> fetchProducts({int limit = 30}) async {
    final url = Uri.parse('$baseUrl/products/list?limit=$limit');

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['results']; // Return in form of list.
      } else {
        throw Exception("Failed to fetch products: ${response.statusCode}");
      }
    } catch (error) {
      rethrow;
    }
  }
}

// It store all the required value in simplified way.
class Item {
  final String images, name;
  final double value;

  Item({
    required this.images,
    required this.name,
    required this.value,
  });
}

Item item(Map<String, dynamic> json) => Item(
      images: json['images'][0]['url'],
      name: json['name'],
      value: json['price']['value'],
    );
