import 'package:equatable/equatable.dart';
import '../../../domain/entities/article.dart';

abstract class ArticlesState extends Equatable {
  const ArticlesState();

  @override
  List<Object?> get props => [];
}

class ArticlesInitial extends ArticlesState {
  const ArticlesInitial();
}

class ArticlesLoading extends ArticlesState {
  const ArticlesLoading();
}

class ArticlesLoaded extends ArticlesState {
  final List<Article> articles;

  const ArticlesLoaded(this.articles);

  @override
  List<Object?> get props => [articles];
}

class ArticlesError extends ArticlesState {
  final String message;

  const ArticlesError(this.message);

  @override
  List<Object?> get props => [message];
}
