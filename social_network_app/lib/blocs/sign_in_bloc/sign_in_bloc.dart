import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_network_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:social_network_app/blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:social_network_app/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInProcess());
      try {
        await _userRepository.signIn(
          event.email,
          event.password,
        );
        emit(SignInSuccess());
      } catch (e) {
        log(e.toString());
        emit(const SignInFailure());
      }
    });
    on<SignOutRequired>((event, emit) async {
      BlocProvider.of<MyUserBloc>(event.context).add(const ResetMyUser());
      BlocProvider.of<BottomNavigationBloc>(event.context).add(const BottomNavigationChanged(0));
      await _userRepository.signOut();
    });
  }
}
