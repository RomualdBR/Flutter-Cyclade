import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cyclade/services/databaseService.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import '../models/userModel.dart';


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

  final _formKey = GlobalKey<FormState>();
  late String _nom;
  late String _prenom;
  late String _email;
  late String _age;
  late String _adresse;
  final bool _role = false;
  final String _id_motivation = "0";
  late String _mot_de_passe;
  late String _mot_de_passe_confirmation;

  @override
  void initState() {
    super.initState();
    MongoDatabase.connect(); // Ensure connection is made at the start.
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var _id = ObjectId();
      final newUser = User(
        id: _id.toString(),
        nom: _nom,
        prenom: _prenom,
        email: _email,
        age: int.parse(_age),
        adresse: _adresse,
        role: _role,
        id_motivation: _id_motivation,
        mot_de_passe: _mot_de_passe,
      );
      var result = await MongoDatabase.insert(newUser);
      print(result); // Log or display result to confirm success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("S'inscrire")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom'),
                keyboardType: TextInputType.text,
                onSaved: (value) => _nom = value.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Prénom'),
                keyboardType: TextInputType.text,
                onSaved: (value) => _prenom = value.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  return null;
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                onSaved: (value) => _age = value.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Adresse'),
                keyboardType: TextInputType.multiline,
                onSaved: (value) => _adresse = value.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse';
                  }
                  return null;
                },
              ),
              
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                keyboardType: TextInputType.text,
                onSaved: (value) => _mot_de_passe = value.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le mot de passe ne doit pas être vide';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirmation de mot de passe'),
                keyboardType: TextInputType.text,
                onSaved: (value) => _mot_de_passe_confirmation = value.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le mot de passe ne doit pas être vide';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child: const Text("S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
