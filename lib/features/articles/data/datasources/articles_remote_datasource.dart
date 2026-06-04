import '../../../../core/error/exceptions.dart';
import '../models/article_model.dart';
import '../models/save_result_model.dart';

abstract class ArticlesRemoteDataSource {
  Future<List<ArticleModel>> getArticles();
  Future<SaveResultModel> saveArticle(String articleId);
  Future<SaveResultModel> unsaveArticle(String articleId);
}

class MockArticlesRemoteDataSource implements ArticlesRemoteDataSource {
  static const _mockArticles = [
    ArticleModel(
      id: 'a1',
      title: 'Getting started with async Dart',
      author: 'Jane Smith',
      preview: 'Futures, streams, and why they matter...',
    ),
    ArticleModel(
      id: 'a2',
      title: 'Flutter performance tips for 2025',
      author: 'Tom Lee',
      preview: 'const widgets, RepaintBoundary, and more...',
    ),
    ArticleModel(
      id: 'a3',
      title: 'Designing APIs that last',
      author: 'Priya Rao',
      preview: 'Versioning, pagination, and error contracts...',
    ),
  ];

  @override
  Future<List<ArticleModel>> getArticles() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockArticles;
  }

  // Simulated API — logic preserved exactly as provided in the spec.
  // Succeeds ~80% of the time, fails ~20%.
  @override
  Future<SaveResultModel> saveArticle(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (DateTime.now().millisecondsSinceEpoch % 10 < 2) {
      throw ServerException(message: 'Network error — please try again');
    }
    return SaveResultModel(articleId: articleId, saved: true);
  }

  @override
  Future<SaveResultModel> unsaveArticle(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (DateTime.now().millisecondsSinceEpoch % 10 < 2) {
      throw ServerException(message: 'Network error — please try again');
    }
    return SaveResultModel(articleId: articleId, saved: false);
  }
}
