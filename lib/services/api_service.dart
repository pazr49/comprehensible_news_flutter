import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../utils/constants.dart';

class ApiService {
  static Future<List<Article>> fetchArticles(String language, String level) async {
    print('Fetching articles');
    final response = await http.get(Uri.parse('${Constants.baseUrl}/articles/$language/$level'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Article.fromJson(item)).toList();
    } else {
      print('Failed to load articles. Status code: ${response.statusCode}');
      throw Exception('Failed to load articles');
    }
  }

  static Future<Article> fetchArticleByID(String articleID) async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/article_by_id?id=$articleID'));

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Decoded JSON: $jsonResponse');
      try {
        Article article = Article.fromJson(jsonResponse);
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

static Future<List<Article>> fetchArticlesByGroupID(String articleGroupID, String language) async {
  final response = await http.get(Uri.parse('${Constants.baseUrl}/article_group/$language?id=$articleGroupID'));

  if (response.statusCode == 200) {
    try {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Article> articles = jsonResponse.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } catch (e) {
      print('Error fetching article: $e');
      throw Exception('Failed to load article');
    }
  } else {
    print('Failed to load article. Status code: ${response.statusCode}');
    throw Exception('Failed to load article');
  }
}
}