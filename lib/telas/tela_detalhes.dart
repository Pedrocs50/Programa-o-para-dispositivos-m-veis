import 'package:flutter/material.dart';

class TelaDetalhesReceita extends StatelessWidget {
  final String titulo;
  final String imagem;
  final List<dynamic> ingredientes;
  final String modoPreparo;

  const TelaDetalhesReceita({
    required this.titulo,
    required this.imagem,
    required this.ingredientes,
    required this.modoPreparo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem da receita
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                imagem,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingredientes:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...ingredientes.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(fontSize: 16)),
                            Expanded(
                              child: Text(item, style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      )),

                  SizedBox(height: 20),
                  Text(
                    'Modo de Preparo:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    modoPreparo,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
