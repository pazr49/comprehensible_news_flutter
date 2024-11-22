import './article_content.dart';
import 'dart:convert';

class Article {
  final String articleID;
  final List<ArticleContent> content;
  final String imageUrl;
  final String targetLanguage;
  final String targetLevel;
  final String url;
  final String title;
  final String articleGroupID;

  Article({
    required this.articleID,
    required this.content,
    required this.imageUrl,
    required this.targetLanguage,
    required this.targetLevel,
    required this.url,
    required this.title,
    required this.articleGroupID,
  });

factory Article.fromJson(Map<String, dynamic> json) {
  var contentData = json['content'];

  // Check if contentData is a String, and if so, parse it
  if (contentData is String) {
    try {
      contentData = jsonDecode(contentData);
    } catch (e) {
      print('Error parsing content: $e');
      contentData = [];
    }
  }

  return Article(
    articleID: json['article_id'] ?? '',
    content: (contentData as List<dynamic>?)
            ?.map((item) => ArticleContent.fromJson(item))
            .toList() ?? [],
    imageUrl: json['image_url'] ?? '',
    targetLanguage: json['language'] ?? '',
    targetLevel: json['level'] ?? '',
    url: json['original_url'] ?? '',
    title: json['title'] ?? '',
    articleGroupID: json['article_group_id'] ?? '',
  );
}
}