import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/services/databaseService.dart';

// Page de connexion utilisateur
class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ConnexionPage> {
  // Clé pour identifier le formulaire et permettre sa validation
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _mot_de_passe;
  String formErrorText = ""; // Texte d'erreur pour afficher les erreurs de validation

  // Fonction de connexion de l'utilisateur
  void _getUser() async {
    if (_formKey.currentState!.validate()) { // Vérifie si le formulaire est valide
      _formKey.currentState!.save(); // Sauvegarde les valeurs des champs
      
      // Authentifie l'utilisateur via un appel à la base de données
      final user = await MongoDatabase.authenticateUser(_email, _mot_de_passe);

      if (user != null) {
        userData = user; // Stocke les données utilisateur si l'authentification réussit
        Navigator.pushNamed(context, '/'); // Redirige vers la page d'accueil
      } else {
        // Affiche un message d'erreur si l'authentification échoue
        setState(() {
          formErrorText = "Email ou mot de passe incorrect";
        });
      }
    }
  }

  // Construction de l'interface de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Se connecter"), // Titre de la page
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Marge autour du formulaire
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ de saisie pour l'email avec validation
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => 
                    EmailValidator.validate(value!) // Vérifie si l'email est valide
                        ? null
                        : "Please enter a valid email",
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value.toString(),
              ),
              // Champ de saisie pour le mot de passe avec validation
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                keyboardType: TextInputType.text,
                onSaved: (value) => _mot_de_passe = value.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) { 
                    return 'Le mot de passe ne doit pas être vide'; // Vérifie que le mot de passe n'est pas vide
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20), // Espace entre les champs et le bouton
              
              // Affiche un message d'erreur en cas de problème d'authentification
              Text(
                formErrorText,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              
              // Bouton pour se connecter
              ElevatedButton(
                onPressed: _getUser, // Lance la connexion de l'utilisateur
                child: const Text("Se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
