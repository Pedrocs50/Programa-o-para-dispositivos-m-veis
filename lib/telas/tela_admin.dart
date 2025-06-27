import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaAdminReceitas extends StatefulWidget {
  @override
  State<TelaAdminReceitas> createState() => _TelaAdminReceitasState();
}

class _TelaAdminReceitasState extends State<TelaAdminReceitas> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _ingredientesController = TextEditingController();
  final _modoPreparoController = TextEditingController();
  final _imagemController = TextEditingController();

  final CollectionReference receitasRef =
      FirebaseFirestore.instance.collection('receitas');

  Future<void> adicionarReceita() async {
    try {
      print('Tentando adicionar receita...');
      if (!_formKey.currentState!.validate()) {
        print('Formulário inválido');
        return;
      }

      final receitaNova = {
        'titulo': _tituloController.text,
        'descricao': _descricaoController.text,
        'ingredientes': _ingredientesController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        'modoPreparo': _modoPreparoController.text,
        'imagem': _imagemController.text,
      };

      await receitasRef.add(receitaNova);
      print('Receita adicionada com sucesso');

      // Limpar campos
      _tituloController.clear();
      _descricaoController.clear();
      _ingredientesController.clear();
      _modoPreparoController.clear();
      _imagemController.clear();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Receita adicionada com sucesso')));
    } catch (e, stack) {
      print('Erro ao adicionar receita: $e');
      print(stack);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao adicionar receita: $e')));
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _ingredientesController.dispose();
    _modoPreparoController.dispose();
    _imagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Receitas'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: InputDecoration(labelText: 'Título'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Informe o título' : null,
                  ),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: InputDecoration(labelText: 'Descrição'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Informe a descrição' : null,
                  ),
                  TextFormField(
                    controller: _ingredientesController,
                    decoration: InputDecoration(
                        labelText: 'Ingredientes (separados por vírgula)'),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Informe ao menos um ingrediente'
                        : null,
                  ),
                  TextFormField(
                    controller: _modoPreparoController,
                    decoration: InputDecoration(labelText: 'Modo de preparo'),
                    maxLines: 3,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Informe o modo de preparo'
                        : null,
                  ),
                  TextFormField(
                    controller: _imagemController,
                    decoration:
                        InputDecoration(labelText: 'Caminho da imagem (local ou URL)'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Informe a imagem' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: adicionarReceita,
                    child: Text('Adicionar Receita'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      minimumSize: Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Receitas cadastradas:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: receitasRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Erro ao carregar receitas: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) return Text('Nenhuma receita cadastrada ainda.');

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['titulo'] ?? 'Sem título'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await receitasRef.doc(doc.id).delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Receita excluída com sucesso')),
                              );
                            } catch (e) {
                              print('Erro ao excluir receita: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao excluir receita: $e')),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          // Para futura edição
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
