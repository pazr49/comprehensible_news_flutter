import 'package:flutter/material.dart';
import '../models/article.dart';
import '../screens/article_detail_screen.dart';

class ArticleItem extends StatelessWidget {
  final Article article;

  ArticleItem({required this.article});

  String getFlagEmoji(String languageCode) {
    switch (languageCode) {
      case 'es':
        return '🇪🇸'; // Spanish flag
      case 'en':
        return '🇬🇧'; // British flag for English
      case 'fr':
        return '🇫🇷'; // French flag
      default:
        return '🏳️'; // Default flag
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to article detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(
              groupID: article.articleGroupID,
              targetLanguage: article.targetLanguage,
              targetLevel: article.targetLevel,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
              ),
              // Gradient Overlay for Contrast
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(1), // Darker at the bottom
                        Colors.black.withOpacity(0.5), // Mid-opacity
                        Colors.transparent, // Fades to transparent
                      ],
                      stops: [0.1, 0.4, 1.0], // Control where the colors change
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              // Article Info
              Positioned(
                bottom: 15,
                left: 15,
                right: 15,
                child: Text(
                  article.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              // Language and Level Badges
              Positioned(
                top: 15,
                right: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBadge(getFlagEmoji(article.targetLanguage)),
                    SizedBox(height: 5),
                    _buildBadge('Level ${article.targetLevel}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
