import '../../domain/entities/save_result.dart';

class SaveResultModel extends SaveResult {
  const SaveResultModel({required super.articleId, required super.saved});

  factory SaveResultModel.fromJson(Map<String, dynamic> json) {
    return SaveResultModel(
      articleId: json['articleId'] as String,
      saved: json['saved'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'articleId': articleId, 'saved': saved};
  }
}
