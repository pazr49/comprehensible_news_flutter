// lib/simplified_article.dart

import 'package:logging/logging.dart';

class SimplifiedArticle {
  final String title;
  final String simplifiedID;
  final String url;
  final String targetLevel;
  final String imageUrl;

  SimplifiedArticle({
    required this.title,
    required this.simplifiedID,
    required this.url,
    required this.targetLevel,
    required this.imageUrl,
  });

  factory SimplifiedArticle.fromJson(Map<String, dynamic> json) {
    SimplifiedArticle article =  SimplifiedArticle(
      title: json['title'] ?? '',
      simplifiedID: json['simplified_id'] ?? '',
      url: json['url'] ?? '',
      targetLevel: json['level'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
    // Use a logging framework instead of print statements
    final log = Logger('Article');
    return article;
  }
}
