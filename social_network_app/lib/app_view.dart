import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/sign_in_bloc/sign_in_bloc.dart';
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
            return BlocProvider(
              create: (context) => SignInBloc(
                userRepository: context.read<AuthenticationBloc>().userRepository,
              ),
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
