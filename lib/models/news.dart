import 'dart:convert';

class News {
  final String title;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;
  DateTime? savedAt;

  News({
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'url': url,
      'urlToImage': imageUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'savedAt': savedAt?.toIso8601String(),
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    if (map.containsKey('savedAt')) {
      //for saved_news
      return News(
        title: map['title'] ?? '',
        url: map['url'] ?? '',
        imageUrl: map['urlToImage'] ?? '',
        publishedAt: DateTime.parse(map['publishedAt'] ?? ''),
        savedAt: DateTime.parse(map['savedAt'] ?? ''),
      );
    } else {
      //for api
      return News(
        title: map['title'] ?? '',
        url: map['url'] ?? '',
        imageUrl: map['urlToImage'] ?? '',
        publishedAt: DateTime.parse(map['publishedAt'] ?? ''),
      );
    }
  }

  String toJson() => json.encode(toMap());

  factory News.fromJson(String source) =>
      News.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'News(title: $title, url: $url, imageUrl: $imageUrl, publishedAt: $publishedAt, savedAt: $savedAt)';
  }
}
