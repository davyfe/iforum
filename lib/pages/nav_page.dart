import 'package:flutter/material.dart';
import '../widget/build_text.dart';
import '/domain/noticia.dart';
import '/cores.dart';

class NavPage extends StatefulWidget {
  final Noticia noticia;

  const NavPage({super.key, required this.noticia});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Cores.verde,
            pinned: true,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.noticia.urlImagem,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                        stops: [0.3, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    right: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.noticia.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "Por ${widget.noticia.autor}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.chevron_right,
                              size: 15,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search_outlined,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.share_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.flag_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Publicado em ${widget.noticia.data}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black38,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.noticia.texto,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  Text("Comentários (5)"),
                  _buildComentarios(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // COLOCAR WIDGET DEPOIS
  Widget _buildComentarios() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundColor: Cores.avatar),
              SizedBox(width: 8),
              Text(
                "camila_rosa",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text("15m"),
              Spacer(),
              Icon(Icons.more_horiz),
            ],
          ),
          SizedBox(height: 5),
          Text(
            "Os comentários são todos iguais!! Estamos em uma matrix??!!",
            style: TextStyle(fontSize: 15),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          buildInteracao(16, 2, "😱"),
          SizedBox(height: 10),
          const Divider(color: Colors.black54, thickness: 0.2, height: 1),
          SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundColor: Cores.avatar),
              SizedBox(width: 8),
              Text(
                "mauro.coelho",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text("7m"),
              Spacer(),
              Icon(Icons.more_horiz),
            ],
          ),
          SizedBox(height: 5),
          Text(
            "Que besteira dessa camila...",
            style: TextStyle(fontSize: 15),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          buildInteracao(8, 2, "😤"),
          SizedBox(height: 10),
          const Divider(color: Colors.black54, thickness: 0.2, height: 1),
          SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundColor: Cores.avatar),
              SizedBox(width: 8),
              Text(
                "remus_lupim",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text("2m"),
              Spacer(),
              Icon(Icons.more_horiz),
            ],
          ),
          SizedBox(height: 5),
          Text(
            "Pessoal... Vamos prestar atenção na matéria.",
            style: TextStyle(fontSize: 15),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          buildInteracao(12, 1, "🌕"),
          SizedBox(height: 10),
          const Divider(color: Colors.black54, thickness: 0.2, height: 1),
          SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundColor: Cores.avatar),
              SizedBox(width: 8),
              Text(
                "katniss.everdeen12",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text("30s"),
              Spacer(),
              Icon(Icons.more_horiz),
            ],
          ),
          SizedBox(height: 5),
          Text(
            "Are you, are you coming to the tree?",
            style: TextStyle(fontSize: 15),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          buildInteracao(3, 0, "🥺"),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildInteracao(int likes, int comentarios, String reacao) {
    return Row(
      children: [
        Chip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.thumb_up_alt_outlined,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 6),
              Text('$likes |'),
              const SizedBox(width: 8),
              const Icon(
                Icons.thumb_down_alt_outlined,
                size: 16,
                color: Colors.black54,
              ),
            ],
          ),
          labelPadding: const EdgeInsets.only(left: 4, right: 2),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        SizedBox(width: 10),
        Chip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 6),
              Text('$comentarios'),
            ],
          ),
          labelPadding: const EdgeInsets.only(left: 4, right: 2),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        Spacer(),
        Chip(
          label: Text(
            reacao,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          labelPadding: const EdgeInsets.only(left: 2, right: 2),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
      ],
    );
  }
}
