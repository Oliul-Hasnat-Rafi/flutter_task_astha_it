class BookModel {
  final String id;
  final String title;
  final String authors;
  final String image;
  final String description;
  final String? publishedDate;

  const BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.image,
    required this.description,
    this.publishedDate,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};

    final authorsList = volumeInfo['authors'] as List<dynamic>?;
    final publishedDate = volumeInfo['publishedDate'] as String?;

    return BookModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'No Title',
      authors: authorsList != null ? authorsList.join(', ') : 'Unknown Author',
      image: (volumeInfo['imageLinks']?['thumbnail'] ?? '')
          .toString()
          .replaceFirst('http://', 'https://'),
      description: volumeInfo['description'] ?? 'No Description Available',
      publishedDate: publishedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'volumeInfo': {
        'title': title,
        'authors': authors.split(', '),
        'imageLinks': {
          'thumbnail': image,
        },
        'description': description,
        'publishedDate': publishedDate,
      }
    };
  }
}