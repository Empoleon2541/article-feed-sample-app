import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/save_article_usecase.dart';
import '../../../domain/usecases/unsave_article_usecase.dart';
import 'save_article_state.dart';

class SaveArticleCubit extends Cubit<SaveArticleState> {
  final SaveArticleUseCase saveArticleUseCase;
  final UnsaveArticleUseCase unsaveArticleUseCase;

  SaveArticleCubit({
    required this.saveArticleUseCase,
    required this.unsaveArticleUseCase,
  }) : super(const SaveArticleInitial());

  Future<void> saveArticle(String articleId) async {
    if (state is SaveArticleSuccess) return;

    emit(const SaveArticleLoading());

    final result = await saveArticleUseCase(
      SaveArticleParams(articleId: articleId),
    );

    result.fold(
      (failure) => emit(SaveArticleFailure(failure.message)),
      (_) => emit(const SaveArticleSuccess()),
    );
  }

  Future<void> unsaveArticle(String articleId) async {
    if (state is! SaveArticleSuccess) return;

    emit(const SaveArticleLoading());

    final result = await unsaveArticleUseCase(
      UnsaveArticleParams(articleId: articleId),
    );

    result.fold(
      (failure) => emit(SaveArticleFailure(failure.message)),
      (_) => emit(const SaveArticleInitial()),
    );
  }
}
