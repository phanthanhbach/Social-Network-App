part of 'update_user_info_bloc.dart';

abstract class UpdateUserInfoState extends Equatable {
  const UpdateUserInfoState();

  @override
  List<Object> get props => [];
}

class UpdateUserInfoInitial extends UpdateUserInfoState {}

// Change Profile Picture

class UploadPictureLoading extends UpdateUserInfoState {}

class UploadPictureSuccess extends UpdateUserInfoState {
  final String userImage;

  const UploadPictureSuccess(this.userImage);

  @override
  List<Object> get props => [userImage];
}

class UploadPictureFailure extends UpdateUserInfoState {}

// Change User Name

class UpdateUserNameLoading extends UpdateUserInfoState {}

class UpdateUserNameSuccess extends UpdateUserInfoState {
  final String name;

  const UpdateUserNameSuccess(this.name);

  @override
  List<Object> get props => [name];
}

class UpdateUserNameFailure extends UpdateUserInfoState {}
