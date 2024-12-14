import 'package:act_autonoma_1/navigation/drawer.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MiLista2 extends StatefulWidget {
  const MiLista2({super.key});

  @override
  State<MiLista2> createState() => _MiLista2State();
}

class _MiLista2State extends State<MiLista2> {
  late TextEditingController _searchController;
  List<dynamic> _videojuegos = [];
  List<dynamic> _videojuegosFiltrados = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchVideojuegos("https://jritsqmet.github.io/web-api/video_juegos.json");

    // Escuchar cambios en el campo de búsqueda
    _searchController.addListener(() {
      _filtrarVideojuegos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchVideojuegos(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _videojuegos = data['videojuegos'];
          _videojuegosFiltrados = _videojuegos;
          _isLoading = false;
        });
      } else {
        throw Exception("Error al cargar los datos");
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filtrarVideojuegos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _videojuegosFiltrados = _videojuegos
          .where((videojuego) => videojuego['titulo']
              .toString()
              .toLowerCase()
              .contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Juegos"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Buscar videojuegos",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text("Error: $_errorMessage"))
                    : ListView.builder(
                        itemCount: _videojuegosFiltrados.length,
                        itemBuilder: (context, index) {
                          final item = _videojuegosFiltrados[index];
                          return ListTile(
                            title: Column(
                              children: [
                                Text("${item['titulo']}"),
                                Image.network(
                                  item['imagen'],
                                  width: 100,
                                  height: 150,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                      .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.error,
                                        size: 100,
                                        color: Colors.red,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      drawer: MiDrawer(),
    );
  }
}
