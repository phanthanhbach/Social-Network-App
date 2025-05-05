part of 'delete_post_bloc.dart';

abstract class DeletePostState extends Equatable {
  const DeletePostState();

  @override
  List<Object> get props => [];
}

final class DeletePostInitial extends DeletePostState {}

final class DeletePostLoading extends DeletePostState {}

final class DeletePostSuccess extends DeletePostState {
  final Post post;
  const DeletePostSuccess({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}

final class DeletePostFailure extends DeletePostState {}
