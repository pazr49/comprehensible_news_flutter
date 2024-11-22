import 'package:flutter/material.dart';
import '../models/article.dart';
import '../screens/article_detail_screen.dart';

class ArticleItem extends StatelessWidget {
  final Article article;

  ArticleItem({required this.article});

  String getFlagEmoji(String languageCode) {
    switch (languageCode) {
      case 'es':
        return '🇨🇴'; // Colombian flag for Spanish
      case 'en':
        return '🇬🇧'; // English flag
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
      child: Card(
        margin: EdgeInsets.zero, // Remove margin to prevent overflow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to fill cross axis
          children: [
            AspectRatio(
              aspectRatio: 16 / 9, // Maintain aspect ratio
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  article.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Language: ${getFlagEmoji(article.targetLanguage)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Level: ${article.targetLevel}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
