import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tela_detalhes.dart'; // Import da tela de detalhes

class TelaFavoritos extends StatefulWidget {
  @override
  _TelaFavoritosState createState() => _TelaFavoritosState();
}

class _TelaFavoritosState extends State<TelaFavoritos> {
  List<Map<String, dynamic>> favoritos = [];

  @override
  void initState() {
    super.initState();
    carregarFavoritos();
  }

  Future<void> carregarFavoritos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    setState(() {
      favoritos = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> desfavoritar(String titulo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(titulo)
        .delete();

    setState(() {
      favoritos.removeWhere((fav) => fav['titulo'] == titulo);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Receita removida dos favoritos')),
    );
  }

  Future<void> abrirDetalhes(String titulo) async {
    // Busca dados completos da receita na coleção 'receitas'
    final receitaSnapshot = await FirebaseFirestore.instance
        .collection('receitas')
        .where('titulo', isEqualTo: titulo)
        .limit(1)
        .get();

    if (receitaSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Detalhes da receita não encontrados')),
      );
      return;
    }

    final data = receitaSnapshot.docs.first.data();

    final imagem = data['imagem'] ?? '';
    final ingredientesRaw = data['ingredientes'];
    final modoPreparo = data['modoPreparo'] ?? '';

    final ingredientes = ingredientesRaw is List
        ? List<String>.from(ingredientesRaw)
        : (ingredientesRaw as String?)?.split(',').map((e) => e.trim()).toList() ?? [];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TelaDetalhesReceita(
          titulo: titulo,
          imagem: imagem,
          ingredientes: ingredientes,
          modoPreparo: modoPreparo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Favoritos'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: favoritos.map((fav) {
          final titulo = fav['titulo'];
          return Card(
            margin: EdgeInsets.all(16),
            child: ListTile(
              title: Text(titulo),
              trailing: Wrap(
                spacing: 10,
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility, color: Colors.orange),
                    tooltip: 'Ver Detalhes',
                    onPressed: () => abrirDetalhes(titulo),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Remover dos favoritos',
                    onPressed: () => desfavoritar(titulo),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
