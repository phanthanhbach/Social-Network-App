part of 'edit_post_bloc.dart';

abstract class EditPostEvent extends Equatable {
  const EditPostEvent();

  @override
  List<Object> get props => [];
}

class EditPostRequested extends EditPostEvent {
  final String postId;
  final String userId;
  final String newContent;
  final String imageUrl;

  const EditPostRequested({
    required this.postId,
    required this.userId,
    required this.newContent,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [postId, userId, newContent, imageUrl];
}
