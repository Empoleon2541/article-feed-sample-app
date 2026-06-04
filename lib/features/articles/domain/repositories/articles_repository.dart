import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../entities/save_result.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<Article>>> getArticles();
  Future<Either<Failure, SaveResult>> saveArticle(String articleId);
  Future<Either<Failure, SaveResult>> unsaveArticle(String articleId);
}
