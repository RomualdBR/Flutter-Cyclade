import 'package:flutter/material.dart';
import 'package:flutter_cyclade/services/databaseService.dart';


class InscriptionPage
    extends StatefulWidget {
  const InscriptionPage(
      {super.key});



  @override
  State<InscriptionPage> createState() =>
      _MyHomePageState();
}



class _MyHomePageState
    extends State<InscriptionPage> {
  int _counter = 0;

  void onPressed() {
    Navigator.pushNamed(context, '/inscription');
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context)
                .colorScheme
                .inversePrimary,
        title: const Text("Inscription"),
      ),
      body: Column(children: []),
      floatingActionButton:
          FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
