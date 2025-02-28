part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final User? user;

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
  });

  /// The AuthenticationStatus is unknown
  const AuthenticationState.unknown() : this._();

  /// The user is authenticated
  const AuthenticationState.authenticated(User user) : this._(status: AuthenticationStatus.authenticated, user: user);

  /// The user is unauthenticated
  const AuthenticationState.unauthenticated() : this._(status: AuthenticationStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}
