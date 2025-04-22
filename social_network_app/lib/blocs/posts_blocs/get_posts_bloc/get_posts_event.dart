part of 'get_posts_bloc.dart';

abstract class GetPostsEvent extends Equatable {
  const GetPostsEvent();

  @override
  List<Object> get props => [];
}

class GetPosts extends GetPostsEvent {}
