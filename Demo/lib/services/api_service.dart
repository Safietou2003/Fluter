import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inscription.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000';

  final Map<String, String> _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<List<Inscription>> getAllInscriptions() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/inscriptions'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<List<Inscription>> getInscriptionsByClass(String classe) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/inscriptions?classe=$classe'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  List<Inscription> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Inscription.fromJson(json)).toList();
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}