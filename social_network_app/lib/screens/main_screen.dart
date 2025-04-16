import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'bluetooth_demo.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    BluetoothDemo(),
    ProfileScreen(),
  ];

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: PageView(
            controller: state.pageController,
            children: MainScreen._screens,
            onPageChanged: (index) {
              context.read<BottomNavigationBloc>().add(BottomNavigationSwiped(index));
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.house_fill,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_fill),
                label: 'Profile',
              ),
            ],
            currentIndex: state.selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            onTap: (index) {
              context.read<BottomNavigationBloc>().add(BottomNavigationChanged(index));
            },
          ),
        );
      },
    );
  }
}
