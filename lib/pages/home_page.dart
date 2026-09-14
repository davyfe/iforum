import 'package:flutter/material.dart';
import '/pages/perfil_page.dart';
import 'explore_page.dart';
import 'noticias_page.dart';
import 'eventos_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  List pages = [
    Explore(),
    Eventos(),
    Noticias(),
    Center(child: Text('Biblioteca', style: TextStyle(fontSize: 32))),
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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'Eventos'),
        BottomNavigationBarItem(
          icon: Icon(Icons.collections_bookmark),
          label: 'Biblioteca',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Notícias'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Você'),
      ],
    );
  }
}
