part of 'get_posts_bloc.dart';

sealed class GetPostsState extends Equatable {
  const GetPostsState();

  @override
  List<Object> get props => [];
}

final class GetPostsInitial extends GetPostsState {}

final class GetPostsLoading extends GetPostsState {}

final class GetPostsSuccess extends GetPostsState {
  final List<PostWithUser> posts;

  const GetPostsSuccess(this.posts);

  @override
  List<Object> get props => [posts];
}

final class GetPostsFailure extends GetPostsState {}
