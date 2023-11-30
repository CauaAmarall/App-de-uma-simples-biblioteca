import 'package:flutter/material.dart';
import 'package:desafio_flutter/models/book_model.dart';
import 'package:desafio_flutter/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class BookshelfScreen extends StatefulWidget {
  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  late ApiService _apiService;
  late List<Book> _books;
  late List<Book> _allBooks = [];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _books = [];
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      List<Book> books = await _apiService.fetchBooks();
      books.forEach((book) => book.isFavorite = false);
      setState(() {
        _allBooks = books;
        _books = List.from(_allBooks);
      });
    } catch (e) {
      print('Erro ao carregar os livros: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Text(
              'Todos',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              _resetBooks();
            },
          ),
          IconButton(
            icon: Text(
              'Favoritos',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              List<Book> favoriteBooks =
                  _allBooks.where((book) => book.isFavorite).toList();
              setState(() {
                _books = favoriteBooks;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: (_books.length / 3).ceil(),
        itemBuilder: (context, rowIndex) {
          int startIndex = rowIndex * 3;
          int endIndex = (rowIndex + 1) * 3;
          endIndex = endIndex > _books.length ? _books.length : endIndex;

          return Row(
            mainAxisAlignment:
                _shouldCenterBooks(endIndex - startIndex, rowIndex)
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceEvenly,
            children: List.generate(endIndex - startIndex, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _launchURL(_books[startIndex + index].downloadUrl);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey[300] ?? Colors.transparent,
                      ),
                    ),
                    width: 100,
                    height: 330,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              _books[startIndex + index].coverUrl,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  _toggleFavorite(_books[startIndex + index]);
                                },
                                child: Icon(
                                  _books[startIndex + index].isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _books[startIndex + index].isFavorite
                                      ? Colors.red
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          _books[startIndex + index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          height: 10,
                          thickness: 2,
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

  bool _shouldCenterBooks(int numberOfBooks, int currentIndex) {
    int totalRows = (_books.length / 3).ceil();

    bool isLastRowSingleBook =
        _books.length % 3 == 1 && currentIndex == totalRows - 1;

    return isLastRowSingleBook;
  }

  void _launchURL(String url) async {
    try {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } catch (e) {
      print('Erro ao lançar a URL: $e');
    }
  }

  void _toggleFavorite(Book book) {
    setState(() {
      book.isFavorite = !book.isFavorite;
    });
  }

  void _resetBooks() {
    setState(() {
      _books = List.from(_allBooks);
    });
  }
}
