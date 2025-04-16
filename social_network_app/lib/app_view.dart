import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_app/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:social_network_app/screens/main_screen.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';

import 'screens/authentication/welcome_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Network App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFA594F9),
          onPrimary: Colors.white,
          secondary: Color(0xFFCDC1FF),
          onSecondary: Colors.black,
          tertiary: Colors.green,
          error: Colors.redAccent,
          surface: Color(0xFFF5EFFF),
          surfaceContainer: Color(0xFFFBFBFB),
          onSurface: Colors.black,
          outline: Color(0xFF424242),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 3,
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            context.read<MyUserBloc>().add(
                  GetMyUser(myUserId: state.user!.uid),
                );
            return const MainScreen();
          } else {
            return const WelcomeScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
