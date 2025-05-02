import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_app/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:social_network_app/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/my_user_bloc/my_user_bloc.dart';
import 'user_info_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      primary: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: BlocBuilder<MyUserBloc, MyUserState>(
        builder: (context, state) {
          return Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  right: 16,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserInfoScreen(),
                        ),
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),
                ),
              ),
              state.user?.profilePicture == ""
                  ? Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                      child: Icon(
                        CupertinoIcons.person,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(state.user!.profilePicture!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 32,
                alignment: Alignment.center,
                child: Text(
                  state.user?.name ?? 'No name',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      CupertinoIcons.square_arrow_right,
                    ),
                    label: const Text('Logout'),
                    onPressed: () {
                      // Logout functionality
                      context.read<SignInBloc>().add(SignOutRequired(context: context));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
