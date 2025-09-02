import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/Health%20Records/view/health_records_view.dart';
import 'package:glycosync/screens/Patients/Profile/view/profile_view.dart';
import 'package:glycosync/screens/Patients/home/view/home_view.dart';

import '../appointments/view/appointment_view.dart';

class PatientsNavBar extends StatefulWidget {
  const PatientsNavBar({super.key});

  @override
  State<PatientsNavBar> createState() => _PatientsNavBarState();
}

class _PatientsNavBarState extends State<PatientsNavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    AppointmentView(),
    HealthRecordsView(),
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
      extendBody: true, // Allows the body to go behind the transparent navbar
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // *** THESE ARE THE CHANGES FOR TRANSPARENCY ***
        backgroundColor: Colors.white, // Makes the background transparent
        elevation: 0, // Removes the shadow

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            activeIcon: Icon(Icons.favorite),
            label: 'Records',
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