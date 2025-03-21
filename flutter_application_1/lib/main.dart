import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escolhendo Comida',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: MyHomePage(title: 'Escolha aleatória'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int inter_counter = 0;

  // List of food items
  List<String> comidas = [
    "Maçã", "Pera", "Melancia", "Banana",
  ];

  // List of colors
  List<MaterialColor> cores = [
    Colors.orange,
    Colors.blue,
    Colors.yellow,
  ];

  String randomTexto = "";
  MaterialColor randomColor = Colors.blue;

  void _atualizaTela() {
    setState(() {
      randomTexto = comidas[Random().nextInt(comidas.length)];
      randomColor = cores[Random().nextInt(cores.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              randomTexto,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: randomColor,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _atualizaTela,
              child: Text('Escolher aleatoriamente'),
            ),
          ],
        ),
      ),
    );
  }
}







// // APLICATIVO COM O TEXTO NO MEIO
// import 'package:flutter/material.dart';

// void main() => runApp(MaterialApp(
//   home:Scaffold(
//     appBar: AppBar(
//       title: Text('Fluter layouts'),
//       centerTitle: true,
//       backgroundColor: Colors.amber,
//     ),
//     body:Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("TEXTO"),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.access_alarm),
//               Icon(Icons.assessment),
//               Icon(Icons.access_alarms),
//             ],
//           )
//         ],
//       ),
//     ),
//   ),
// ),
// );