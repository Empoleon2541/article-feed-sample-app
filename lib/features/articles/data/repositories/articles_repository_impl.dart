import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/entities/save_result.dart';
import '../../domain/repositories/articles_repository.dart';
import '../datasources/articles_remote_datasource.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesRemoteDataSource remoteDataSource;

  ArticlesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Article>>> getArticles() async {
    try {
      final articles = await remoteDataSource.getArticles();
      return Right(articles);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, SaveResult>> saveArticle(String articleId) async {
    try {
      final result = await remoteDataSource.saveArticle(articleId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaveResult>> unsaveArticle(String articleId) async {
    try {
      final result = await remoteDataSource.unsaveArticle(articleId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
