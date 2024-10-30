import 'package:flutter/material.dart';

class ResultatsPage extends StatefulWidget {
  const ResultatsPage({super.key});

  @override
  State<ResultatsPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ResultatsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Résultats")),
    );
  }
}