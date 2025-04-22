part of 'create_post_bloc.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

class CreatePost extends CreatePostEvent {
  final Post post;
  final String? imagePath;

  const CreatePost(this.post, this.imagePath);

  @override
  List<Object> get props => [post];
}
