part of 'edit_post_bloc.dart';

sealed class EditPostState extends Equatable {
  const EditPostState();

  @override
  List<Object> get props => [];
}

final class EditPostInitial extends EditPostState {}

final class EditPostLoading extends EditPostState {}

final class EditPostSuccess extends EditPostState {
  final Post post;

  const EditPostSuccess(this.post);

  @override
  List<Object> get props => [post];
}

final class EditPostFailure extends EditPostState {
  final String error;

  const EditPostFailure(this.error);

  @override
  List<Object> get props => [error];
}
