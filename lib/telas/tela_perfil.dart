import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaPerfil extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  void enviarEmailRedefinicaoSenha(BuildContext context) async {
    if (user == null) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email de redefinição enviado para ${user!.email}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nome = user?.displayName ?? 'Usuário';
    final email = user?.email ?? 'Sem email';

    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Perfil'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, $nome!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.orange[50],
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dados Pessoais',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Email: $email'),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => enviarEmailRedefinicaoSenha(context),
                      icon: Icon(Icons.lock_reset),
                      label: Text('Alterar Senha'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                      ),
                    ),
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
