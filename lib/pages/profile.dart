import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/services/databaseService.dart';
import 'package:flutter_cyclade/models/userModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cyclade/UserProvider.dart';
import 'package:flutter_cyclade/models/motivationModel.dart';
import 'package:flutter_cyclade/motivationProvider.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProfilePage> {
  final _formkey = GlobalKey<FormState>();
  String prenom = userData.prenom.toString();
  String nom = userData.nom.toString();
  String email = userData.email.toString();
  String adresse = userData.adresse.toString();
  String formErrorText = "";
  List<Motivation> motivations = [];
  String _selectedMotivationId = userData.id_motivation;

  List<Map<String, dynamic>> userPassedTests = [];

  @override
  void initState() {
    super.initState();
    Provider.of<MotivationProvider>(context, listen: false).loadMotivations();
    _loadUserPassedTests();
  }

  Future<void> _loadUserPassedTests() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var tests = await MongoDatabase.getPassedTests();
    setState(() {
      userPassedTests = tests.where((test) => test['user_name'] == userProvider.user.nom).toList();
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final motivationProvider = Provider.of<MotivationProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Prénom : ${userProvider.user.prenom}"),
                  Text("Nom : ${userProvider.user.nom}"),
                  Text("Email : ${userProvider.user.email}"),
                  Text("Adresse : ${userProvider.user.adresse}"),
                  Text("Age : ${userProvider.user.age}"),
                  Text("Motivation : ${userProvider.user.id_motivation}"),
                  if (userData.role == true) Text("Rôle : " + userData.role.toString()),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Nouvelle adresse"),
                    initialValue: userProvider.user.adresse,
                    onChanged: (value) => setState(() => adresse = value),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Nouvel email"),
                    initialValue: userProvider.user.email,
                    onChanged: (value) => setState(() => email = value),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Nouveau nom"),
                    initialValue: userProvider.user.nom,
                    onChanged: (value) => setState(() => nom = value),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Nouveau prénom"),
                    initialValue: userProvider.user.prenom,
                    onChanged: (value) => setState(() => prenom = value),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Motivation'),
                    value: userData.id_motivation,
                    items: motivationProvider.motivations.map((motivation) {
                      return DropdownMenuItem<String>(
                        value: motivation.id,
                        child: Text(motivation.nom),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedMotivationId = value!),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Veuillez sélectionner une motivation'
                        : null,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final updatedUser = User(
                        id: userProvider.user.id,
                        nom: nom,
                        prenom: prenom,
                        email: email,
                        adresse: adresse,
                        age: userProvider.user.age,
                        role: userProvider.user.role,
                        id_motivation: _selectedMotivationId,
                        mot_de_passe: userProvider.user.mot_de_passe,
                      );
                      userProvider.updateUser(updatedUser);
                    },
                    child: const Text("Mettre à jour"),
                  ),
                  if (formErrorText.isNotEmpty)
                    Text(
                      formErrorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ElevatedButton(
                    onPressed: () => {
                      userProvider.disconnectUser(),
                      Navigator.pushNamed(context, '/'),
                    },
                    child: const Text("Se déconnecter"),
                  ),
                ],
              ),
            ),
            const Divider(height: 32.0, thickness: 2.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: const Text(
                "Résultats de vos tests passés",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            userPassedTests.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: userPassedTests.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var test = userPassedTests[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.assignment, color: Colors.blueGrey),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Test: ${test['test_name']}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, color: Colors.teal),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Date: ${formatDate(test['date'])}",
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Score: ${test['score']}/${test['question_count']}",
                                        style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
