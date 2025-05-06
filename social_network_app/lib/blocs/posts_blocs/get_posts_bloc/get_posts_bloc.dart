import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'get_posts_event.dart';
part 'get_posts_state.dart';

class GetPostsBloc extends Bloc<GetPostsEvent, GetPostsState> {
  final PostRepository _postRepository;
  final UserRepository _userRepository;

  GetPostsBloc({required PostRepository postRepository, required UserRepository userRepository})
      : _postRepository = postRepository,
        _userRepository = userRepository,
        super(GetPostsInitial()) {
    on<GetPosts>((event, emit) async {
      emit(GetPostsLoading());
      try {
        List<Post> posts = await _postRepository.getPost();

        // Lấy danh sách userId từ các bài viết
        final userIds = posts.map((post) => post.userId).toSet().toList();

        // Lấy thông tin người dùng từ UserRepository
        final users = await _userRepository.getUsersByIds(userIds);

        // Tạo một map để ánh xạ userId -> MyUser
        final userMap = {for (var user in users) user.id: user};

        // Kết hợp thông tin người dùng vào bài viết
        final postsWithUsers = posts.map((post) {
          final user = userMap[post.userId];
          return PostWithUser(post: post, user: user!);
        }).toList();

        emit(GetPostsSuccess(postsWithUsers));
      } catch (e) {
        emit(GetPostsFailure());
      }
    });
  }
}
