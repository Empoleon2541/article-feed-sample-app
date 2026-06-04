import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/article.dart';
import '../repositories/articles_repository.dart';

class GetArticlesUseCase implements UseCase<List<Article>, NoParams> {
  final ArticlesRepository repository;

  GetArticlesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(NoParams params) async {
    return await repository.getArticles();
  }
}
