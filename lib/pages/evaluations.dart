import 'package:flutter/material.dart';

class EvaluationsPage extends StatefulWidget {
  const EvaluationsPage({super.key});

  @override
  State<EvaluationsPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EvaluationsPage> {
  void java() {}
  void algo() {}
  void htmlcss() {}

  // Contenu de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Evaluations"),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ElevatedButton(
          onPressed: java,
          child: const Text("Java"),
        ),
        ElevatedButton(
          onPressed: algo,
          child: const Text("Algorithmie"),
        ),
        ElevatedButton(
          onPressed: htmlcss,
          child: const Text("HTML/CSS"),
        ),
      ]),
    );
  }
}
