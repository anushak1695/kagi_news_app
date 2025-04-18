class Category {
  final String name;
  final String file;
  final int articleCount;

  Category({
    required this.name,
    required this.file,
    required this.articleCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String,
      file: json['file'] as String,
      articleCount: json['articleCount'] as int? ?? 0,
    );
  }
} 