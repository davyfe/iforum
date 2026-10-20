import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/api/address_api.dart';
import '/api/geocoding_api.dart';
import '/widget/build_text.dart';
import '/cores.dart';

class MapaNoticiasPage extends StatefulWidget {
  const MapaNoticiasPage({super.key});

  @override
  State<MapaNoticiasPage> createState() => _MapaNoticiasPageState();
}

class _MapaNoticiasPageState extends State<MapaNoticiasPage> {
  final _cepController = TextEditingController();
  GoogleMapController? _mapController;
  Marker? _marcador;
  String? _endereco;
  bool _carregando = false;

  // posição inicial: Arapiraca (aproximada)
  static const _inicial = CameraPosition(
    target: LatLng(-9.7525, -36.6611),
    zoom: 13,
  );

  @override
  void dispose() {
    _cepController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _erro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _buscar() async {
    final cep = _cepController.text.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) {
      _erro('Digite um CEP com 8 números.');
      return;
    }

    setState(() => _carregando = true);

    try {
      final address = await AddressApi().findByCep(cep);
      if (address == null) {
        _erro('CEP não encontrado.');
        return;
      }

      final texto =
          '${address.logradouro}, ${address.bairro}, ${address.localidade} - ${address.uf}, Brasil';

      final geo = GeocodingApi();
      // se a rua não for achada, tenta só a cidade
      final posicao = await geo.buscarCoordenadas(texto) ??
          await geo.buscarCoordenadas(
            '${address.localidade}, ${address.uf}, Brasil',
          );

      if (posicao == null) {
        _erro('Não foi possível localizar no mapa.');
        return;
      }

      setState(() {
        _endereco = texto;
        _marcador = Marker(
          markerId: const MarkerId('busca'),
          position: posicao,
          infoWindow: InfoWindow(title: address.logradouro),
        );
      });

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(posicao, 16),
      );
    } catch (e) {
      _erro('Erro ao conectar. Tente novamente.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Cores.verde,
        title: BuildText('Mapa', bold: true, color: Colors.white, size: 20),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _buscar(),
              decoration: InputDecoration(
                hintText: 'Buscar por CEP...',
                prefixIcon: const Icon(Icons.location_on_outlined),
                suffixIcon: _carregando
                    ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                    : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscar,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (_endereco != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: BuildText(
                _endereco!,
                size: 13,
                color: Cores.textoTerciario,
              ),
            ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _inicial,
              markers: {if (_marcador != null) _marcador!},
              onMapCreated: (c) => _mapController = c,
            ),
          ),
        ],
      ),
    );
  }
}