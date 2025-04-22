part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class BottomNavigationChanged extends BottomNavigationEvent {
  final int selectedIndex;

  const BottomNavigationChanged(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];

  @override
  String toString() => 'BottomNavigationChanged { selectedIndex: $selectedIndex }';
}

class BottomNavigationSwiped extends BottomNavigationEvent {
  final int selectedIndex;

  const BottomNavigationSwiped(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];

  @override
  String toString() => 'BottomNavigationSwiped { selectedIndex: $selectedIndex }';
}
