import 'package:flutter/material.dart';
import '../models/article.dart';
import '../widgets/article_grid.dart';
import '../widgets/filter_dialog.dart';
import '../services/api_service.dart';
import '../widgets/category_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedLevel = 'A1';
  String _selectedLanguage = 'en'; // Default to English
  String _selectedCategory = 'todays-news'; // Default selected category
  late Future<List<Article>> _articlesFuture;
  List<Article> _allArticles = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _fetchArticles();
  }

  Future<List<Article>> _fetchArticles() async {
    try {
      final articles = await ApiService.fetchArticlesByTag(_selectedCategory, _selectedLanguage);
      setState(() {
        _allArticles = articles;
      });
      return articles;
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading articles';
      });
      return [];
    }
  }

  void _onCategorySelected(String selectedCategory) {
    setState(() {
      _selectedCategory = selectedCategory;
      _articlesFuture = _fetchArticles();
    });
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
        _selectedLanguage = result['language'] ?? _selectedLanguage;
        _articlesFuture = _fetchArticles();
      });
    }
  }

  String getFlagAsset(String languageCode) {
    // Map the selected language code to the corresponding flag asset
    switch (languageCode) {
      case 'es':
        return 'assets/flags/flag-co.png'; // Spanish flag
      case 'en':
        return 'assets/flags/flag-gb.png'; // English flag
      case 'fr':
        return 'assets/flags/flag-fr.png'; // French flag
      default:
        return 'assets/flags/default.png'; // Default flag (optional)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Discover',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Image.asset(
                getFlagAsset(_selectedLanguage), // Get the flag image for the selected language
                height: 24,
                width: 32,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Add the category buttons at the top of the feed
          CategoryButtons(
            initialSelectedCategory: _selectedCategory,
            onCategorySelected: _onCategorySelected, // Pass the callback function
          ),
          const SizedBox(height: 10), // Add spacing between buttons and feed
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: _articlesFuture,
              builder: (context, snapshot) {
                if (_errorMessage != null) {
                  return Center(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ArticleGrid(articles: snapshot.data!);
                } else {
                  return const Center(child: Text('No articles found'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFilterDialog,
        child: const Icon(Icons.filter_list),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
