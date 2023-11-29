import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_teste/models/book_model.dart';

class ApiService {
  static const String apiUrl =
      'https://escribo.com/books.json'; // Substitua pela URL real da sua API.

  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar a lista de livros');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
