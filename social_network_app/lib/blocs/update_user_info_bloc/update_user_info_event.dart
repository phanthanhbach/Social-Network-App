part of 'update_user_info_bloc.dart';

abstract class UpdateUserInfoEvent extends Equatable {
  const UpdateUserInfoEvent();

  @override
  List<Object> get props => [];
}

class UploadPicture extends UpdateUserInfoEvent {
  final String filePath;
  final String userId;

  const UploadPicture(this.filePath, this.userId);

  @override
  List<Object> get props => [filePath, userId];
}
