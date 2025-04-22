import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:social_network_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:social_network_app/blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:social_network_app/blocs/posts_blocs/get_posts_bloc/get_posts_bloc.dart';
import 'package:social_network_app/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:social_network_app/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:social_network_app/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'app_view.dart';

class MainApp extends StatelessWidget {
  final UserRepository userRepository;
  const MainApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationBloc>(create: (_) => AuthenticationBloc(myUserRepository: userRepository)),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SignInBloc(
                userRepository: context.read<AuthenticationBloc>().userRepository,
              ),
            ),
            BlocProvider(
              create: (context) => UpdateUserInfoBloc(
                userRepository: context.read<AuthenticationBloc>().userRepository,
              ),
            ),
            BlocProvider(
              create: (context) => MyUserBloc(
                myUserRepository: context.read<AuthenticationBloc>().userRepository,
              )..add(GetMyUser(myUserId: context.read<AuthenticationBloc>().state.user!.uid)),
            ),
            BlocProvider(
              create: (context) => GetPostsBloc(
                  postRepository: FirebasePostRepository(),
                  userRepository: context.read<AuthenticationBloc>().userRepository)
                ..add(GetPosts()),
            ),
            BlocProvider(
              create: (context) => BottomNavigationBloc()..add(const BottomNavigationChanged(0)),
            ),
          ],
          child: const MyAppView(),
        ));
  }
}
