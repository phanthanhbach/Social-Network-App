part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInRequired extends SignInEvent {
  final String email;
  final String password;

  const SignInRequired(
    this.email,
    this.password,
  );
}

class SignOutRequired extends SignInEvent {
  final BuildContext context;

  const SignOutRequired({
    required this.context,
  });
}
