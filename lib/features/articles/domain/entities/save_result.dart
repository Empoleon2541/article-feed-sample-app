import 'package:equatable/equatable.dart';

class SaveResult extends Equatable {
  final String articleId;
  final bool saved;

  const SaveResult({required this.articleId, required this.saved});

  @override
  List<Object> get props => [articleId, saved];
}
