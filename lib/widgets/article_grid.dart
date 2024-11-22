import 'package:flutter/material.dart';
import '../models/article.dart';
import 'article_item.dart';

class ArticleGrid extends StatelessWidget {
  final List<Article> articles;

  const ArticleGrid({Key? key, required this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define desired min and max item widths
    const double minItemWidth = 350;
    const double maxItemWidth = 350;
    const double aspectRatio = 1; // height = width * aspectRatio

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the number of columns based on the available width
        int columns = (constraints.maxWidth / minItemWidth).floor();

        // Ensure at least 1 column
        columns = columns > 0 ? columns : 1;

        // Calculate the item width
        double itemWidth = constraints.maxWidth / columns;

        // Ensure item width does not exceed maxItemWidth
        if (itemWidth > maxItemWidth) {
          itemWidth = maxItemWidth;
          columns = (constraints.maxWidth / itemWidth).floor();
        }

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
            return ArticleItem(article: articles[index]);
          },
        );
      },
    );
  }
}
