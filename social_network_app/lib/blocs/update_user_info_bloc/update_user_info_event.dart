part of 'update_user_info_bloc.dart';

abstract class UpdateUserInfoEvent extends Equatable {
  const UpdateUserInfoEvent();

  @override
  List<Object> get props => [];
}

class UploadPicture extends UpdateUserInfoEvent {
  final String filePath;
  final String userId;

  const UploadPicture(
    this.filePath,
    this.userId,
  );

  @override
  List<Object> get props => [filePath, userId];
}

class UpdateUserName extends UpdateUserInfoEvent {
  final String userId;
  final String name;

  const UpdateUserName(
    this.userId,
    this.name,
  );

  @override
  List<Object> get props => [userId, name];
}
