import 'package:act_autonoma_1/main.dart';
import 'package:act_autonoma_1/screens/lista1.dart';
import 'package:act_autonoma_1/screens/lista2.dart';
import 'package:flutter/material.dart';

class MiDrawer extends StatelessWidget {
  const MiDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Menu"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> MainApp())),
          ),
          ListTile(
            title: Text("Personajes de Lol"),
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> MiLista1())),
          ),
          ListTile(
            title: Text("Video Juegos"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> MiLista2())),
          )
        ],
      ),
    );
  }
}