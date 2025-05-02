part of 'edit_post_bloc.dart';

abstract class EditPostEvent extends Equatable {
  const EditPostEvent();

  @override
  List<Object> get props => [];
}

class EditPostRequested extends EditPostEvent {
  final Post post;
  final String imageUrl;

  const EditPostRequested({
    required this.post,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [post, imageUrl];
}
