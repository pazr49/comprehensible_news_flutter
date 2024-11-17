// lib/article.dart

import 'package:logging/logging.dart';

class Article {
  final String title;
  final String articleID;
  final String url;
  final String targetLevel;
  final String targetLanguage;
  final String imageUrl;

  Article({
    required this.title,
    required this.articleID,
    required this.url,
    required this.targetLevel,
    required this.targetLanguage,
    required this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    Article article =  Article(
      title: json['title'] ?? '',
      articleID: json['article_id'] ?? '',
      url: json['url'] ?? '',
      targetLevel: json['level'] ?? '',
      targetLanguage: json['language'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
    // Use a logging framework instead of print statements
    final log = Logger('Article');
    return article;
  }
}
