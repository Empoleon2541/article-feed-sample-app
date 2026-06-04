import 'package:get_it/get_it.dart';
import '../../features/articles/data/datasources/articles_remote_datasource.dart';
import '../../features/articles/data/repositories/articles_repository_impl.dart';
import '../../features/articles/domain/repositories/articles_repository.dart';
import '../../features/articles/domain/usecases/get_articles_usecase.dart';
import '../../features/articles/domain/usecases/save_article_usecase.dart';
import '../../features/articles/domain/usecases/unsave_article_usecase.dart';
import '../../features/articles/presentation/bloc/articles/articles_cubit.dart';
import '../../features/articles/presentation/bloc/save_article/save_article_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // ========== Articles Feature ==========

  // Data Sources
  sl.registerLazySingleton<ArticlesRemoteDataSource>(
    () => MockArticlesRemoteDataSource(),
  );

  // Repository
  sl.registerLazySingleton<ArticlesRepository>(
    () => ArticlesRepositoryImpl(remoteDataSource: sl<ArticlesRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetArticlesUseCase(sl<ArticlesRepository>()));
  sl.registerLazySingleton(() => SaveArticleUseCase(sl<ArticlesRepository>()));
  sl.registerLazySingleton(() => UnsaveArticleUseCase(sl<ArticlesRepository>()));

  // Cubits (factory — new instance per creation)
  sl.registerFactory<ArticlesCubit>(
    () => ArticlesCubit(getArticlesUseCase: sl<GetArticlesUseCase>()),
  );
  sl.registerFactory<SaveArticleCubit>(
    () => SaveArticleCubit(
      saveArticleUseCase: sl<SaveArticleUseCase>(),
      unsaveArticleUseCase: sl<UnsaveArticleUseCase>(),
    ),
  );
}
