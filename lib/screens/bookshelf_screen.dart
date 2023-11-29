import 'package:flutter/material.dart';
import 'package:flutter_teste/models/book_model.dart';
import 'package:flutter_teste/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
        itemCount: (_books.length / 3).ceil(),
        itemBuilder: (context, rowIndex) {
          int startIndex = rowIndex * 3;
          int endIndex = (rowIndex + 1) * 3;
          endIndex = endIndex > _books.length ? _books.length : endIndex;

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(endIndex - startIndex, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _launchURL(_books[startIndex + index].downloadUrl);
                  },
                  child: Container(
                    width: 100,
                    height: 310,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          _books[startIndex + index].coverUrl,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8),
                        Text(
                          _books[startIndex + index].title,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          _books[startIndex + index].author,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
