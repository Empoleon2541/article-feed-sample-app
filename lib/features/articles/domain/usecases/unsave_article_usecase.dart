import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/save_result.dart';
import '../repositories/articles_repository.dart';

class UnsaveArticleUseCase implements UseCase<SaveResult, UnsaveArticleParams> {
  final ArticlesRepository repository;

  UnsaveArticleUseCase(this.repository);

  @override
  Future<Either<Failure, SaveResult>> call(UnsaveArticleParams params) {
    return repository.unsaveArticle(params.articleId);
  }
}

class UnsaveArticleParams {
  final String articleId;
  const UnsaveArticleParams({required this.articleId});
}
