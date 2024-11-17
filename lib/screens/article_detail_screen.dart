import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/article.dart';
import '../models/article_content.dart';
import '../services/api_service.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String articleID;

  ArticleDetailScreen({required this.articleID});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF5F5F5), // Set the status bar color
        statusBarIconBrightness: Brightness.dark, // Set the status bar icon color
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5), // Light grey background color
        body: FutureBuilder<ArticleContent>(
          future: ApiService.fetchArticleByID(articleID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final article = snapshot.data!;
              print('Article simplifiedText: ${article.content}');
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    backgroundColor: Color(0xFFF5F5F5),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              article.imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            article.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...jsonDecode(article.content).map<Widget>((contentItem) {
                            if (contentItem['type'] == 'image') {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Image.network(
                                  contentItem['content'],
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else if (contentItem['type'] == 'paragraph') {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  contentItem['content'],
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Container(); // Handle other states if necessary
            }
          },
        ),
      ),
    );
  }
}