import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_articles_usecase.dart';
import 'articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final GetArticlesUseCase getArticlesUseCase;

  ArticlesCubit({required this.getArticlesUseCase})
      : super(const ArticlesInitial());

  Future<void> loadArticles() async {
    emit(const ArticlesLoading());

    final result = await getArticlesUseCase(NoParams());

    result.fold(
      (failure) => emit(ArticlesError(failure.message)),
      (articles) => emit(ArticlesLoaded(articles)),
    );
  }
}
