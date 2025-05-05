import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';

part 'delete_post_event.dart';
part 'delete_post_state.dart';

class DeletePostBloc extends Bloc<DeletePostEvent, DeletePostState> {
  final PostRepository _postRepository;

  DeletePostBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(DeletePostInitial()) {
    on<DeletePostRequested>((event, emit) async {
      emit(DeletePostLoading());
      try {
        await _postRepository.deletePost(event.post);
        emit(DeletePostSuccess(post: event.post));
      } catch (e) {
        emit(DeletePostFailure());
      }
    });
  }
}
