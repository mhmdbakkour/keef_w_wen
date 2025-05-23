import 'package:flutter/material.dart';
import '../../data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  //TODO: Try to remove the propagation animation
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedIndex, child) {
        return BottomNavigationBar(
          fixedColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          unselectedItemColor: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(160),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          elevation: 8,
          showUnselectedLabels: false,
          onTap: (index) {
            selectedPageNotifier.value = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_outlined),
              activeIcon: Icon(Icons.event),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'People',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}
