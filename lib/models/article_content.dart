// lib/article_content.dart

import 'package:logging/logging.dart';

class ArticleContent {
  final String content;
  final String articleID;
  final String title;
  final String targetLevel;
  final String targetLanguage;
  final String imageUrl;


  ArticleContent({
    required this.content,
    required this.articleID,
    required this.title,
    required this.targetLevel,
    required this.targetLanguage,
    required this.imageUrl,
  });

  factory ArticleContent.fromJson(Map<String, dynamic> json) {
    ArticleContent articleContent = ArticleContent(
      articleID: json['article_id'] ?? '',
      title: json['title'] ?? '',
      content: json['simplified_text'] ?? '',
      targetLevel: json['level'] ?? '',
      targetLanguage: json['language'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
    // Use a logging framework instead of print
    final log = Logger('ArticleContent');
    return articleContent;
  }
}