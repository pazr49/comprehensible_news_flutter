import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/article.dart';
import '../widgets/article_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedLevel;
  String? selectedLanguage;
  Future<List<Article>>? articlesFuture;

  @override
  void initState() {
    super.initState();
    articlesFuture = ApiService.fetchArticles();
  }

  void _openFilterDialog() async {
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (context) {
        String? level;
        String? language;
        return AlertDialog(
          title: Text('Filter Articles'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Level'),
                items: ['A1', 'A2', 'B1']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  level = value;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Language'),
                items: ['en', 'es', 'fr']
                    .map((language) => DropdownMenuItem(
                          value: language,
                          child: Text(language),
                        ))
                    .toList(),
                onChanged: (value) {
                  language = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'level': level,
                  'language': language,
                });
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedLevel = result['level'];
        selectedLanguage = result['language'];
        articlesFuture = ApiService.fetchArticles().then((articles) {
          return articles.where((article) {
            final matchesLevel = selectedLevel == null || article.targetLevel == selectedLevel;
            final matchesLanguage = selectedLanguage == null || article.targetLanguage == selectedLanguage;
            return matchesLevel && matchesLanguage;
          }).toList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200], // Set the background color to a darker grey
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make Scaffold background transparent
        appBar: AppBar(
          title: Text('Comprehensible news', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: _openFilterDialog,
            ),
          ],
        ),
        body: FutureBuilder<List<Article>>(
          future: articlesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final articles = snapshot.data!;
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return ArticleItem(article: articles[index]);
                },
              );
            } else {
              return Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }
}