import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../models/article_content.dart';
import '../models/simplified_article.dart';
import '../utils/constants.dart';

class ApiService {
  static Future<List<Article>> fetchArticles() async {
    print('Fetching articles');
    final response = await http.get(Uri.parse('${Constants.baseUrl}/articles'));

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Article.fromJson(item)).toList();
    } else {
      print('Failed to load articles. Status code: ${response.statusCode}');
      throw Exception('Failed to load articles');
    }
  }

  static Future<List<SimplifiedArticle>> fetchSimplifiedArticles() async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/simplified_articles'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => SimplifiedArticle.fromJson(item)).toList();
    } else {
      print('Failed to load simplified articles. Status code: ${response.statusCode}');
      throw Exception('Failed to load simplified articles');
    }
  }

  static Future<ArticleContent> fetchArticleByID(String articleID) async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/article_by_id?id=$articleID'));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Decoded JSON: $jsonResponse');
      try {
        ArticleContent article = ArticleContent.fromJson(jsonResponse);
        print('Article created: $article');
        return article;
      } catch (e) {
        print('Error: $e');
        throw Exception('Failed to load article');
      }
    } else {
      print('Failed to load article. Status code: ${response.statusCode}');
      throw Exception('Failed to load article');
    }
  }
}