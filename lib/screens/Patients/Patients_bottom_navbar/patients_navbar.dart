import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/home/view/home_view.dart';
import 'package:glycosync/screens/Patients/routine/view/routine_view.dart';
import 'package:glycosync/screens/Patients/profile/view/profile_view.dart';

class PatientsNavBar extends StatefulWidget {
  const PatientsNavBar({super.key});

  @override
  State<PatientsNavBar> createState() => _PatientsNavBarState();
}

class _PatientsNavBarState extends State<PatientsNavBar> {
  int _selectedIndex = 1;

  // --- NEW: A GlobalKey to access the HomeView's state ---
  final GlobalKey<HomeViewState> _homeViewKey = GlobalKey<HomeViewState>();

  // --- MODIFIED: The list of widgets is now late-initialized ---
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const RoutineView(),
      // Pass the key to the HomeView instance
      HomeView(key: _homeViewKey),
      const ProfileView(),
    ];
  }

  void _onItemTapped(int index) {
    // --- NEW: Check if the Home tab is tapped and refresh its data ---
    if (index == 1) {
      _homeViewKey.currentState?.refreshData();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
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
