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
        List<Book> books = data.map((json) => Book.fromJson(json)).toList();

        // Imprima os dados da API
        print('Dados da API: $data');

        return books;
      } else {
        throw Exception('Falha ao carregar a lista de livros');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
