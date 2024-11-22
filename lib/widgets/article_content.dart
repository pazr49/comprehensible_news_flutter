import 'package:flutter/material.dart';
import '../models/article.dart';
import '../constants/colors.dart';

class ArticleContent extends StatelessWidget {
  final Article article;

  const ArticleContent({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 600,  // Minimum width
          maxWidth: 800, // Maximum width
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: backgroundColor,
              title: Text(article.title),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  article.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display article content
                    ...article.content.map<Widget>((contentItem) {
                      if (contentItem.type == 'image') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Image.network(
                            contentItem.content,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else if (contentItem.type == 'paragraph') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: SelectableText(
                            contentItem.content,
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }).toList(),
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
