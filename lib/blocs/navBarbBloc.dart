// ignore_for_file: constant_identifier_names

import 'dart:async';

enum NavBarItem { HOME, FIND, DISEAS }

class BottomNavBarBloc {
  final StreamController<NavBarItem> _navBarController = StreamController<NavBarItem>.broadcast();

  NavBarItem defaultItem = NavBarItem.HOME;
  int currentIndex = 0;

  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItem.HOME);
        currentIndex = i;
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.FIND);
        currentIndex = i;
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.DISEAS);
        currentIndex = i;
        break;
    }
  }

  void close() {
    _navBarController.close();
  }
}
