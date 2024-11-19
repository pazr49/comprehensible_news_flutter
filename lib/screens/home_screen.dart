import 'package:flutter/material.dart';
import '../models/article.dart';
import '../widgets/article_item.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
        String? level = selectedLevel;
        String? language = selectedLanguage;
        return AlertDialog(
          title: Text('Filter Articles'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Level'),
                items: ['A1', 'A2', 'B1']
                    .map((lvl) => DropdownMenuItem(
                          value: lvl,
                          child: Text(lvl),
                        ))
                    .toList(),
                value: level,
                onChanged: (value) {
                  level = value;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Language'),
                items: ['Spanish', 'French']
                    .map((lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                        ))
                    .toList(),
                value: language,
                onChanged: (value) {
                  language = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without changes
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop({'level': level, 'language': language});
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: [
          if (selectedLevel != null || selectedLanguage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  '${selectedLevel ?? ''} ${selectedLanguage ?? ''}'.trim(),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _openFilterDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Article> articles = snapshot.data!;

            // Apply filters if any
            if (selectedLevel != null || selectedLanguage != null) {
              articles = articles.where((article) {
                final matchesLevel = selectedLevel == null || article.targetLevel == selectedLevel;
                final matchesLanguage = selectedLanguage == null || article.targetLanguage == selectedLanguage;
                return matchesLevel && matchesLanguage;
              }).toList();
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                int columns = (constraints.maxWidth / 360).floor();
                columns = columns > 1 ? columns : 1;
                double aspectRatio = 1;

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    childAspectRatio: aspectRatio,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return AspectRatio(
                      aspectRatio: aspectRatio,
                      child: ArticleItem(article: articles[index]),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading articles'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
