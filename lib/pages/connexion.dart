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

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ConnexionPage> {
  final _formKey =
      GlobalKey<FormState>();
  late String _email;
  late String _mot_de_passe;

  String formErrorText = "";

  @override
  void initState() {
    super.initState();
  }

  void _getUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Authenticate user
      final user = await MongoDatabase.authenticateUser(_email, _mot_de_passe);

      if (user != null) {
        userData = user;
        // User authenticated successfully, redirect to home page
        Navigator.pushNamed(context, '/');
      } else {
        // Display error message if authentication fails
        setState(() {
          formErrorText = "Email ou mot de passe incorrect";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              const Text("Se connecter")),
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
              const SizedBox(
                  height: 20),
              Text(
                formErrorText,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16),
              ),
              ElevatedButton(
                onPressed: _getUser,
                child: const Text(
                    "Se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
