import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/save_result.dart';
import '../repositories/articles_repository.dart';

class SaveArticleUseCase implements UseCase<SaveResult, SaveArticleParams> {
  final ArticlesRepository repository;

  SaveArticleUseCase(this.repository);

  @override
  Future<Either<Failure, SaveResult>> call(SaveArticleParams params) async {
    return await repository.saveArticle(params.articleId);
  }
}

class SaveArticleParams extends Equatable {
  final String articleId;

  const SaveArticleParams({required this.articleId});

  @override
  List<Object> get props => [articleId];
}
