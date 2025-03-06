import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:social_network_app/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:social_network_app/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:social_network_app/screens/authentication/sign_in_screen.dart';
import 'package:social_network_app/screens/authentication/sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: kToolbarHeight,
                  ),
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: kToolbarHeight,
                  ),
                  TabBar(
                      controller: _tabController,
                      unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      labelColor: Theme.of(context).colorScheme.onSurface,
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerHeight: 0,
                      tabs: const [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ]),
                  Flexible(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        BlocProvider<SignInBloc>(
                          create: (context) => SignInBloc(
                            userRepository: context.read<AuthenticationBloc>().userRepository,
                          ),
                          child: const SignInScreen(),
                        ),
                        BlocProvider<SignUpBloc>(
                          create: (context) => SignUpBloc(
                            userRepository: context.read<AuthenticationBloc>().userRepository,
                          ),
                          child: const SignUpScreen(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
