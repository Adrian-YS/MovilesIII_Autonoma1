import 'dart:convert';
import 'package:act_autonoma_1/navigation/drawer.dart';
import 'package:flutter/material.dart';

class MiLista1 extends StatelessWidget {
  const MiLista1({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListaLoL(),
    );
  }
}

class ListaLoL extends StatefulWidget {
  const ListaLoL({super.key});

  @override
  _ListaLoLState createState() => _ListaLoLState();
}

class _ListaLoLState extends State<ListaLoL> {
  List<dynamic> personajes = [];
  List<dynamic> personajesFiltrados = [];
  final TextEditingController controladorBusqueda = TextEditingController();

  Future<void> cargarJson(BuildContext context) async {
    final String response =
        await DefaultAssetBundle.of(context).loadString('assets/personajes.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      personajes = data;
      personajesFiltrados = data; 
    });
  }

  void filtrarPersonajes(String query) {
    setState(() {
      if (query.isEmpty) {
        personajesFiltrados = personajes;
      } else {
        personajesFiltrados = personajes.where((personaje) {
          final nombre = personaje["nombre"].toLowerCase();
          final descripcion = personaje["descripcion"].toLowerCase();
          return nombre.contains(query.toLowerCase()) ||
              descripcion.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cargarJson(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personajes de League of Legends"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controladorBusqueda,
              onChanged: filtrarPersonajes,
              decoration: const InputDecoration(
                labelText: "Buscar",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: personajesFiltrados.isEmpty
                ? const Center(child: Text("No se encontraron resultados"))
                : ListView.builder(
                    itemCount: personajesFiltrados.length,
                    itemBuilder: (context, index) {
                      final personaje = personajesFiltrados[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(
                            personaje["imagen"],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(personaje["nombre"]),
                          subtitle: Text(personaje["descripcion"]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      drawer: const MiDrawer(),
    );
  }
}
