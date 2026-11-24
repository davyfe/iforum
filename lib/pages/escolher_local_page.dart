import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/cores.dart';

// Guarda o resultado: nome + ponto no mapa
class LocalEscolhido {
  final String nome;
  final LatLng posicao;
  LocalEscolhido(this.nome, this.posicao);
}

class EscolherLocalPage extends StatefulWidget {
  const EscolherLocalPage({super.key});

  @override
  State<EscolherLocalPage> createState() => _EscolherLocalPageState();
}

class _EscolherLocalPageState extends State<EscolherLocalPage> {
  final _nomeC = TextEditingController();
  LatLng? _escolhido;

  // Ponto onde o mapa abre (IFAL Arapiraca)
  static const LatLng _inicio = LatLng(-9.745411162105748, -36.631326404465156);

  @override
  void dispose() {
    _nomeC.dispose();
    super.dispose();
  }

  void _confirmar() {
    if (_escolhido == null) return;
    final nome = _nomeC.text.trim().isEmpty
        ? 'Local selecionado'
        : _nomeC.text.trim();
    Navigator.pop(context, LocalEscolhido(nome, _escolhido!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Cores.verde,
        title: const Text(
          'Escolher local',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _escolhido == null ? null : _confirmar,
            child: Text(
              'Confirmar',
              style: TextStyle(
                color: _escolhido == null ? Colors.white54 : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _nomeC,
              decoration: const InputDecoration(
                hintText: 'Nome do local (ex: Biblioteca)',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Toque no mapa para marcar o ponto'),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition:
              const CameraPosition(target: _inicio, zoom: 16),
              onTap: (ponto) => setState(() => _escolhido = ponto),
              markers: {
                if (_escolhido != null)
                  Marker(
                    markerId: const MarkerId('escolhido'),
                    position: _escolhido!,
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}