import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

part 'get_posts_event.dart';
part 'get_posts_state.dart';

class GetPostsBloc extends Bloc<GetPostsEvent, GetPostsState> {
  final PostRepository _postRepository;

  GetPostsBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(GetPostsInitial()) {
    on<GetPosts>((event, emit) async {
      emit(GetPostsLoading());
      try {
        List<Post> posts = await _postRepository.getPost();

        emit(GetPostsSuccess(posts));
      } catch (e) {
        emit(GetPostsFailure());
      }
    });
  }
}
