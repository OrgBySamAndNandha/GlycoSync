import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/home/view/home_view.dart';
// Import the new placeholder screens
import 'package:glycosync/screens/Patients/routine/view/routine_view.dart';
import 'package:glycosync/screens/Patients/profile/view/profile_view.dart';

class PatientsNavBar extends StatefulWidget {
  const PatientsNavBar({super.key});

  @override
  State<PatientsNavBar> createState() => _PatientsNavBarState();
}

class _PatientsNavBarState extends State<PatientsNavBar> {
  // Set the initial index to 1 so the app opens on the Home screen
  int _selectedIndex = 1;

  // The list of screens that correspond to the nav bar items
  static const List<Widget> _widgetOptions = <Widget>[
    RoutineView(),
    HomeView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        // Updated the items to the new three-tab structure
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Routine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
