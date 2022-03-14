import 'dart:convert';

import 'package:http/http.dart' as http;

class Requesthelper {
  static Future<dynamic> getresposnse(String url) async {
    try {
      Uri _url = Uri.parse(url);
      var response = await http.get(_url);
      // print('status code--->>>>${response.statusCode}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }
}
