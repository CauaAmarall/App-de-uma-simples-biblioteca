import 'package:flutter/material.dart';
import 'package:flutter_teste/api/api_service.dart';
import 'package:flutter_teste/models/book_model.dart';

class BookshelfScreen extends StatefulWidget {
  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  final ApiService _apiService = ApiService();
  late List<Book> _books;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final books = await _apiService.fetchBooks();
      setState(() {
        _books = books;
      });
    } catch (e) {
      // Lidar com erro de carregamento de livros
      print('Erro ao carregar livros: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estante de Livros'),
      ),
      body: _buildBookshelf(),
    );
  }

  Widget _buildBookshelf() {
    if (_books == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_books.isEmpty) {
      return Center(
        child: Text('Nenhum livro disponível.'),
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          return _buildBookCard(_books[index]);
        },
      );
    }
  }

  Widget _buildBookCard(Book book) {
    return Card(
      child: Column(
        children: [
          Image.network(
            book.coverUrl,
            height: 150.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
          Text(book.title),
        ],
      ),
    );
  }
}
