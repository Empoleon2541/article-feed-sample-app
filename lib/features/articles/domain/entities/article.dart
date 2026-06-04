import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String author;
  final String preview;

  const Article({
    required this.id,
    required this.title,
    required this.author,
    required this.preview,
  });

  @override
  List<Object> get props => [id, title, author, preview];

  @override
  String toString() => 'Article(id: $id, title: $title)';
}
