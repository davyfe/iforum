import 'package:flutter/material.dart';
import '/pages/perfil.dart';
import 'explore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  List pages = [
    Explore(),
    Center(child: Text('Notificações', style: TextStyle(fontSize: 32))),
    Perfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: buildBottomNavBar(),
    );
  }

  buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: Colors.green,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notificações',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Você"),
      ],
    );
  }
}
