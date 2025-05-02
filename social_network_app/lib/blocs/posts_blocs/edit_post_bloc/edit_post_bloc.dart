import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

part 'edit_post_event.dart';
part 'edit_post_state.dart';

class EditPostBloc extends Bloc<EditPostEvent, EditPostState> {
  final PostRepository _postRepository;

  EditPostBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(EditPostInitial()) {
    on<EditPostRequested>((event, emit) async {
      emit(EditPostLoading());
      try {
        Post post = await _postRepository.editPost(
          event.post,
          event.imageUrl,
        );
        emit(EditPostSuccess(post));
      } catch (e) {
        emit(EditPostFailure(e.toString()));
      }
    });
  }
}
