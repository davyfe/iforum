import 'package:flutter/material.dart';
import '/cores.dart';
import 'perfil_page.dart';
import 'explore_page.dart';
import 'noticias_page.dart';
import 'eventos_page.dart';
import 'biblioteca_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  List pages = [Explore(), Eventos(), Biblioteca(), Noticias(), Perfil()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: buildBottomNavBar(),
    );
  }

  BottomNavigationBar buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Cores.fundo,
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
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 0 ? Icons.home : Icons.home_outlined),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            selectedIndex == 1 ? Icons.event_note : Icons.event_note_outlined,
          ),
          label: 'Eventos',
        ),
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 2 ? Icons.book : Icons.book_outlined),
          label: 'Biblioteca',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            selectedIndex == 3 ? Icons.article : Icons.article_outlined,
          ),
          label: 'Notícias',
        ),
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 4 ? Icons.person : Icons.person_outline),
          label: 'Eu',
        ),
      ],
    );
  }
}
