class ArticleContent {
  final String content;
  final String type;

  ArticleContent({
    required this.content,
    required this.type,

  });

  factory ArticleContent.fromJson(Map<String, dynamic> json) {
    return ArticleContent(
      content: json['content'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
