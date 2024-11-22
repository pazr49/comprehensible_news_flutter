import 'package:flutter/material.dart';
import '../models/article.dart';
import '../widgets/article_grid.dart';
import '../widgets/filter_dialog.dart';
import '../services/api_service.dart';
import '../constants/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedLevel = 'A1';
  String? _selectedLanguage = 'en';
  late Future<List<Article>> _articlesFuture;
  List<Article> _allArticles = [];
  List<Article> _filteredArticles = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _fetchArticles();
  }

  Future<List<Article>> _fetchArticles() async {
    try {
      final articles = await ApiService.fetchArticles(_selectedLanguage!, _selectedLevel!);
      setState(() {
        _allArticles = articles;
        _filteredArticles = articles;
      });
      return articles;
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading articles';
      });
      return [];
    }
  }

void _openFilterDialog() async {
  final result = await showDialog<Map<String, String?>>(
    context: context,
    builder: (context) => FilterDialog(
      selectedLevel: _selectedLevel,
      selectedLanguage: _selectedLanguage,
    ),
  );

  if (result != null) {
    setState(() {
      _selectedLevel = result['level'];
      _selectedLanguage = result['language'];
      // Fetch articles with the new filters
      _articlesFuture = _fetchArticles();
    });
  }
}

  void _applyFilters() {
    setState(() {
      _filteredArticles = _allArticles.where((article) {
        final matchesLevel =
            _selectedLevel == null || article.targetLevel == _selectedLevel;
        final matchesLanguage = _selectedLanguage == null ||
            article.targetLanguage == _selectedLanguage;
        return matchesLevel && matchesLanguage;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedLevel = null;
      _selectedLanguage = null;
      _filteredArticles = _allArticles;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: _articlesFuture,
              builder: (context, snapshot) {
                if (_errorMessage != null) {
                  return Center(
                    child: Text(
                      _errorMessage!,
                      style: errorTextStyle,
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return ArticleGrid(articles: snapshot.data!);
                } else {
                  return const Center(child: Text('No articles found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
