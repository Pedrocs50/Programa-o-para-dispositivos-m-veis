import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TelaLogin(),
  ));
}

class TelaLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orangeAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Eixo principal centralizado
          crossAxisAlignment: CrossAxisAlignment.center, // Eixo transversal centralizado
          children: [
            Text(
              'ChefUP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Nome'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TelaInicial()),
                        );
                      },
                      child: Text('Cadastrar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 48),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaInicial extends StatelessWidget {
  final receitas = [
    {
      'imagem': 'assets/images/lasanha_berinjela.jpg',
      'titulo': 'Lasanha de Berinjela',
      'descricao': 'Uma deliciosa receita vegetariana com camadas de berinjela, molho e queijo gratinado.'
    },
    {
      'imagem': 'assets/images/sopa_abobora.jpg',
      'titulo': 'Sopa de Abóbora',
      'descricao': 'Sopa cremosa e nutritiva feita com abóbora e temperos naturais.'
    },
    {
      'imagem': 'assets/images/salada_quinoa.jpg',
      'titulo': 'Salada de Quinoa',
      'descricao': 'Salada leve com quinoa, legumes frescos e molho de limão.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('ChefUP'),
        centerTitle: true, // Título centralizado no AppBar
      ),
      body: ListView(
        children: [
          // Header com alinhamento de texto
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

          // Caixa de busca
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
              ),
            ),
          ),

          SizedBox(height: 20),

          // Título centralizado
          Center(
            child: Text(
              'RECEITAS POPULARES',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFB300),
                letterSpacing: 1,
              ),
            ),
          ),

          SizedBox(height: 20),

          // Lista de receitas
          ...receitas.map((receita) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(receita['imagem']!),
                      fit: BoxFit.cover, // Ajuste da imagem para preencher o espaço
                    ),
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orangeAccent),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Eixo transversal para a esquerda
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          receita['imagem']!,
                          fit: BoxFit.cover, // Ajuste da imagem para cobrir o container
                          width: double.infinity,
                          height: 180,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        receita['titulo']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        receita['descricao']!,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          print("Receita Favoritada: ${receita['titulo']}");
                        },
                        child: Text("Favoritar Receita"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
