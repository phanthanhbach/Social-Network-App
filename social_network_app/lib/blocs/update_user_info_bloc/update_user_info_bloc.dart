import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'update_user_info_event.dart';
part 'update_user_info_state.dart';

class UpdateUserInfoBloc extends Bloc<UpdateUserInfoEvent, UpdateUserInfoState> {
  final UserRepository _userRepository;

  UpdateUserInfoBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UpdateUserInfoInitial()) {
    on<UploadPicture>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        String userImage = await _userRepository.uploadPicture(event.filePath, event.userId);
        emit(UploadPictureSuccess(userImage));
      } catch (e) {
        emit(UploadPictureFailure());
      }
    });

    on<UpdateUserName>((event, emit) async {
      emit(UpdateUserNameLoading());
      try {
        String newName = await _userRepository.updateUserName(event.userId, event.name);
        emit(UpdateUserNameSuccess(newName));
      } catch (e) {
        emit(UpdateUserNameFailure());
      }
    });
  }
}
