import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:social_network_app/blocs/get_posts_bloc/get_posts_bloc.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/my_user_bloc/my_user_bloc.dart';
import 'blocs/sign_in_bloc/sign_in_bloc.dart';
import 'blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'screens/home/home_screen.dart';
import 'screens/authentication/welcome_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Network App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF2196F3),
          onPrimary: Colors.black,
          secondary: Colors.blueAccent,
          onSecondary: Colors.white,
          tertiary: Colors.green,
          error: Colors.red,
          surface: Colors.white,
          onSurface: Colors.black,
          outline: Color(0xFF424242),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          elevation: 3,
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
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
                  create: (context) => GetPostsBloc(postRepository: FirebasePostRepository())..add(GetPosts()),
                ),
              ],
              child: const HomeScreen(),
            );
          } else {
            return const WelcomeScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
