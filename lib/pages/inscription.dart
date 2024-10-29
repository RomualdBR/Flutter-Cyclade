import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/services/databaseService.dart';
import 'package:mongo_dart/mongo_dart.dart'
    show ObjectId;
import '../models/userModel.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_cyclade/models/motivationModel.dart';

class InscriptionPage
    extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage>
      createState() =>
          _MyHomePageState();
}

class _MyHomePageState
    extends State<InscriptionPage> {
  final _formKey =
      GlobalKey<FormState>();
  late String _nom;
  late String _prenom;
  late String _email;
  late String _age;
  late String _adresse;
  final bool _role = false;
  String _id_motivation = "0";
  late String _mot_de_passe;
  late String
      _mot_de_passe_confirmation;
  String formErrorText = "";
  List<Motivation> motivations = [];

  @override
  void initState() {
    super.initState();
    MongoDatabase.connect();
    _loadMotivations();
  }

  Future<void>
      _loadMotivations() async {
    final loadedMotivations =
        await MongoDatabase
            .getAllMotivations();
    setState(() {
      motivations = loadedMotivations;
    });
  }

  void _saveUser() async {
    if (_formKey.currentState!
        .validate()) {
      _formKey.currentState!.save();
      var _id =
          ObjectId().toHexString();
      final newUser = User(
        id: _id.toString(),
        nom: _nom,
        prenom: _prenom,
        email: _email,
        age: int.parse(_age),
        adresse: _adresse,
        role: _role,
        id_motivation: _id_motivation,
        mot_de_passe: encryptPassword(
                _mot_de_passe)
            .toString(),
      );
      if (_mot_de_passe_confirmation ==
          _mot_de_passe) {
        if (await MongoDatabase
                .emailExists(_email) ==
            false) {
          var result =
              await MongoDatabase
                  .insert(newUser);
          userData = newUser;
          Navigator.pushNamed(
              context, '/');
        } else {
          print("L'email existe déja");
          setState(() {
            formErrorText =
                "L'email existe déja";
          });
        }
      } else {
        setState(() {
          formErrorText =
              "Les mots de passe ne correspondent pas";
        });

        print(
            "Les mots de passe ne correspondent pas");
      }
      ;
    }
  }

  String encryptPassword(
      String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<void>
      _createMotivations() async {
    await MongoDatabase
        .createDefaultMotivations();
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
          content: Text(
              'Motivations par défaut créées.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              const Text("S'inscrire")),
      body: Padding(
        padding:
            const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(
                        labelText:
                            'Nom'),
                keyboardType:
                    TextInputType.text,
                onSaved: (value) =>
                    _nom = value
                        .toString(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(
                        labelText:
                            'Prénom'),
                keyboardType:
                    TextInputType.text,
                onSaved: (value) =>
                    _prenom = value
                        .toString(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(
                        labelText:
                            'Email'),
                validator: (value) =>
                    EmailValidator
                            .validate(
                                value!)
                        ? null
                        : "Please enter a valid email",
                keyboardType:
                    TextInputType
                        .emailAddress,
                onSaved: (value) =>
                    _email = value
                        .toString(),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(
                        labelText:
                            'Age'),
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly
                ],
                keyboardType:
                    TextInputType
                        .number,
                onSaved: (value) =>
                    _age = value
                        .toString(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(
                        labelText:
                            'Adresse'),
                keyboardType:
                    TextInputType
                        .multiline,
                onSaved: (value) =>
                    _adresse = value
                        .toString(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Veuillez entrer une adresse';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<
                  String>(
                decoration:
                    const InputDecoration(
                        labelText:
                            'Motivation'),
                items: motivations
                    .map((motivation) {
                  return DropdownMenuItem<
                      String>(
                    value:
                        motivation.id,
                    child: Text(
                        motivation.nom),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _id_motivation =
                        value!;
                  });
                },
                onSaved: (value) =>
                    _id_motivation =
                        value!,
                validator: (value) =>
                    value == null ||
                            value
                                .isEmpty
                        ? 'Veuillez sélectionner une motivation'
                        : null,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(
                        labelText:
                            'Mot de passe'),
                keyboardType:
                    TextInputType.text,
                onSaved: (value) =>
                    _mot_de_passe =
                        value
                            .toString(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Le mot de passe ne doit pas être vide';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(
                        labelText:
                            'Confirmation de mot de passe'),
                keyboardType:
                    TextInputType.text,
                onSaved: (value) =>
                    _mot_de_passe_confirmation =
                        value
                            .toString(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Le mot de passe ne doit pas être vide';
                  }
                  return null;
                },
              ),
              const SizedBox(
                  height: 20),
              Text(
                formErrorText,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16),
              ),
              ElevatedButton(
                onPressed: _saveUser,
                child: const Text(
                    "S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
