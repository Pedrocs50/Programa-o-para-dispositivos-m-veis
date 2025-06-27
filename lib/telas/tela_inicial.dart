import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tela_favoritos.dart';
import 'tela_admin.dart';
import 'tela_detalhes.dart';
import 'tela_perfil.dart'; // Import da tela de perfil

class TelaInicial extends StatefulWidget {
  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  Set<String> favoritos = {};
  String busca = '';

  @override
  void initState() {
    super.initState();
    carregarFavoritos();
  }

  Future<void> carregarFavoritos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    setState(() {
      favoritos = favSnapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  Future<void> favoritarReceita(String titulo) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Você precisa estar logado para favoritar')),
        );
        return;
      }

      final favRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(titulo);

      if (favoritos.contains(titulo)) {
        await favRef.delete();
        setState(() {
          favoritos.remove(titulo);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receita removida dos favoritos')),
        );
      } else {
        await favRef.set({
          'titulo': titulo,
          'favoritadoEm': FieldValue.serverTimestamp(),
        });
        setState(() {
          favoritos.add(titulo);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receita favoritada')),
        );
      }
    } catch (e) {
      print('Erro ao favoritar receita: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao favoritar receita: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('ChefUP'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            tooltip: 'Meus Favoritos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TelaFavoritos()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            tooltip: 'Admin Receitas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TelaAdminReceitas()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            tooltip: 'Meu Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TelaPerfil()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            color: Colors.deepOrange,
            alignment: Alignment.center,
            child: Text(
              'ChefUP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            color: Color(0xFFCCCCCC),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar receitas...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onChanged: (valor) {
                  setState(() {
                    busca = valor;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'RECEITAS POPULARES',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFB300),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('receitas').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final titulo = (data['titulo'] ?? '').toString().toLowerCase();
                  return titulo.contains(busca.toLowerCase());
                }).toList();

                if (docs.isEmpty) {
                  return Center(child: Text('Nenhuma receita encontrada.'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final titulo = data['titulo'] ?? '';
                    final descricao = data['descricao'] ?? '';
                    final imagem = data['imagem'] ?? '';
                    final ingredientesRaw = data['ingredientes'];
                    final modoPreparo = data['modoPreparo'] ?? '';

                    final ingredientes = ingredientesRaw is List
                        ? List<String>.from(ingredientesRaw)
                        : (ingredientesRaw as String?)?.split(',').map((e) => e.trim()).toList() ?? [];

                    final estaFavorita = favoritos.contains(titulo);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orangeAccent),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (imagem.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imagem,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 180,
                                ),
                              ),
                            SizedBox(height: 8),
                            Text(
                              titulo,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              descricao,
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () {
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
                              },
                              icon: Icon(Icons.receipt_long),
                              label: Text('Ver Detalhes'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 44),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () => favoritarReceita(titulo),
                              icon: AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(scale: animation, child: child),
                                child: Icon(
                                  estaFavorita ? Icons.favorite : Icons.favorite_border,
                                  key: ValueKey(estaFavorita),
                                  color: estaFavorita ? Colors.red : Colors.white,
                                ),
                              ),
                              label: Text(
                                estaFavorita ? 'Desfavoritar' : 'Favoritar Receita',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 48),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
