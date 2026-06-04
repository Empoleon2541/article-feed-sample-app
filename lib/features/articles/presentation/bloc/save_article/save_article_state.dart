import 'package:equatable/equatable.dart';

abstract class SaveArticleState extends Equatable {
  const SaveArticleState();

  @override
  List<Object?> get props => [];
}

class SaveArticleInitial extends SaveArticleState {
  const SaveArticleInitial();
}

class SaveArticleLoading extends SaveArticleState {
  const SaveArticleLoading();
}

class SaveArticleSuccess extends SaveArticleState {
  const SaveArticleSuccess();
}

class SaveArticleFailure extends SaveArticleState {
  final String message;

  const SaveArticleFailure(this.message);

  @override
  List<Object?> get props => [message];
}
