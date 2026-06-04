import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.author,
    required super.preview,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      preview: json['preview'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'author': author, 'preview': preview};
  }

  factory ArticleModel.fromEntity(Article article) {
    return ArticleModel(
      id: article.id,
      title: article.title,
      author: article.author,
      preview: article.preview,
    );
  }
}
