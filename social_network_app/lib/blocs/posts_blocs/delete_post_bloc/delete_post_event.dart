part of 'delete_post_bloc.dart';

abstract class DeletePostEvent extends Equatable {
  const DeletePostEvent();

  @override
  List<Object> get props => [];
}

class DeletePostRequested extends DeletePostEvent {
  final Post post;

  const DeletePostRequested({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}
