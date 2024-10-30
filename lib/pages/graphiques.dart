import 'package:flutter/material.dart';

class GraphiquesPage extends StatefulWidget {
  const GraphiquesPage({super.key});

  @override
  State<GraphiquesPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GraphiquesPage> {
  @override
  void initState() {
    super.initState();
  }

  // Contenu de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Graphiques")),
    );
  }
}