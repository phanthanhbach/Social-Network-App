import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  bool _isBottomNavigationTapped = false;

  BottomNavigationBloc() : super(BottomNavigationState(0, PageController())) {
    on<BottomNavigationChanged>((event, emit) {
      _isBottomNavigationTapped = true;
      emit(BottomNavigationState(event.selectedIndex, state.pageController));
      state.pageController.animateToPage(
        event.selectedIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    });

    on<BottomNavigationSwiped>((event, emit) {
      if (!_isBottomNavigationTapped) {
        emit(BottomNavigationState(event.selectedIndex, state.pageController));
        state.pageController.animateToPage(
          event.selectedIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastEaseInToSlowEaseOut,
        );
      }
      _isBottomNavigationTapped = false;
    });
  }

  @override
  Future<void> close() {
    state.pageController.dispose();
    return super.close();
  }
}
