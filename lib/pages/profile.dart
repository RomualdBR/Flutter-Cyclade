import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import '../models/userModel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProfilePage> {
  void _disconnectUser() async {
    if (userData.id != "0") {
      // Si l'utilisateur est connecté
      userData = User(
          id: "0",
          nom: "nom",
          prenom: "prenom",
          email: "email",
          age: 0,
          adresse: "adresse",
          role: false,
          id_motivation: "0",
          mot_de_passe: "mot_de_passe");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
        children: [
          if (userData.id != "0")
            ElevatedButton(
              onPressed: _disconnectUser,
              child: const Text("Se déconnecter"),
            ),
        ],
      ),
    );
  }
}
