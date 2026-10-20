import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iforum/api/address_api.dart';
import 'package:iforum/api/geocoding_api.dart';
import '../widget/build_text.dart';
import '../cores.dart';

class _LocalCampus {
  final Map<String, dynamic>? endereco;
  final LatLng posicao;

  _LocalCampus(this.endereco, this.posicao);
}

class MapaCampusPage extends StatefulWidget {
  const MapaCampusPage({super.key});

  @override
  State<MapaCampusPage> createState() => _MapaCampusPageState();
}

class _MapaCampusPageState extends State<MapaCampusPage> {
  static const cepCampus = '57309005';
  static const nomeCampus = 'Instituto Federal de Alagoas Campus Arapiraca';

  late Future<_LocalCampus> futureLocal;

  @override
  void initState() {
    super.initState();
    futureLocal = _carregar();
  }

  Future<_LocalCampus> _carregar() async {
    Map<String, dynamic>? endereco;
    try {
      endereco = await AddressApi().findByCep(cepCampus);
    } catch (_) {}

    final geocoding = GeocodingApi();
    LatLng? posicao = await geocoding.buscarCoordenadas(nomeCampus);

    if (posicao == null && endereco != null) {
      posicao = await geocoding.buscarCoordenadas(
        '${endereco['logradouro']}, ${endereco['bairro']}, '
            '${endereco['localidade']}, ${endereco['uf']}',
      );
    }

    if (posicao == null) {
      posicao = const LatLng(-9.7561, -36.6578);
    }
    return _LocalCampus(endereco, posicao);
  }

  void recarregar() => setState(() => futureLocal = _carregar());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Cores.verde,
        title: BuildText('Campus Arapiraca',
            bold: true, color: Colors.white, size: 20),
        centerTitle: true,
      ),
      body: FutureBuilder<_LocalCampus>(
        future: futureLocal,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildMapa(snapshot.requireData);
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.grey, size: 48),
                  const SizedBox(height: 8),
                  BuildText('Erro ao carregar o mapa', color: Colors.red),
                  TextButton(
                    onPressed: recarregar,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildMapa(_LocalCampus local) {
    final e = local.endereco;

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: local.posicao, zoom: 16),
          markers: {
            Marker(
              markerId: const MarkerId('campus'),
              position: local.posicao,
              infoWindow: const InfoWindow(title: 'IFAL - Campus Arapiraca'),
            ),
          },
        ),
        if (e != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Cores.verde),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildText('IFAL - Campus Arapiraca', bold: true),
                        BuildText(
                          '${e['logradouro']}, ${e['bairro']}\n'
                              '${e['localidade']} - ${e['uf']}, ${e['cep']}',
                          size: 13,
                          color: Cores.textoTerciario,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}