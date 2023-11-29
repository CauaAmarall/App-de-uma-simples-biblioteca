import 'package:flutter/material.dart';
import 'package:flutter_teste/models/book_model.dart';
import 'package:flutter_teste/services/api_service.dart';

class BookshelfScreen extends StatefulWidget {
  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  late ApiService _apiService;
  late List<Book> _books;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _books = [];
    _fetchBooks(); // Chame a função para carregar os livros ao iniciar a tela
  }

  Future<void> _fetchBooks() async {
    try {
      List<Book> books = await _apiService.fetchBooks();
      setState(() {
        _books = books;
      });
    } catch (e) {
      // Trate possíveis erros ao carregar os livros
      print('Erro ao carregar os livros: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ebook Reader App'),
      ),
      body: ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              width: 100, // Ajuste conforme necessário
              height: 400, // Ajuste conforme necessário
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centralizar os filhos
                children: [
                  Image.network(
                    _books[index].coverUrl,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 8), // Espaçamento entre a imagem e o texto
                  Text(
                    _books[index].title,
                    textAlign: TextAlign.center, // Centralizar o texto
                  ),
                  Text(
                    _books[index].author,
                    textAlign: TextAlign.center, // Centralizar o texto
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
