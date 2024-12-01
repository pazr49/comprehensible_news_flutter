import 'package:flutter/material.dart';
import '../models/article.dart';

class LevelTabs extends StatelessWidget {
  final List<Article> articles;
  final int currentIndex;
  final Function(int) onTabSelected;

  const LevelTabs({
    super.key,
    required this.articles,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: articles.asMap().entries.map((entry) {
            int idx = entry.key;
            Article article = entry.value;
            bool isSelected = idx == currentIndex;

            return GestureDetector(
              onTap: () => onTabSelected(idx),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  article.targetLevel,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
