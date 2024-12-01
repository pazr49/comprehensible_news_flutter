import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../widgets/level_tabs.dart';
import '../widgets/article_content.dart';
import '../constants/colors.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String groupID;
  final String targetLanguage;
  final String targetLevel;

  const ArticleDetailScreen({
    super.key,
    required this.groupID,
    required this.targetLanguage,
    required this.targetLevel,
  });

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;
  List<Article> articles = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    try {
      List<Article> fetchedArticles = await ApiService.fetchArticlesByGroupID(
        widget.groupID,
        widget.targetLanguage,
      );

      // Sort articles in order A1 → A2 → B1
      fetchedArticles.sort((a, b) {
        const levelOrder = {'A1': 1, 'A2': 2, 'B1': 3};
        return (levelOrder[a.targetLevel] ?? 0)
            .compareTo(levelOrder[b.targetLevel] ?? 0);
      });

      setState(() {
        articles = fetchedArticles;
      });
    } catch (e) {
      print('Error fetching articles: $e');
      setState(() {
        _errorMessage = 'Failed to load articles';
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : articles.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      const SliverAppBar(
                        floating: true,
                        snap: true,
                        backgroundColor: backgroundColor,
                        centerTitle: true,
                      ),
                      SliverToBoxAdapter(
                        child: LevelTabs(
                          articles: articles,
                          currentIndex: _currentIndex,
                          onTabSelected: (index) {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                      SliverFillRemaining(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: articles.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return ArticleContent(article: article);
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
