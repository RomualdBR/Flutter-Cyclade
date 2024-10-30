import '../models/userModel.dart';

// Constantes 
const MONGO_CONN_URL = 
  "mongodb+srv://flutterdb123:flutterdb123@cluster0.edmbw.mongodb.net/projet?retryWrites=true&w=majority&appName=Cluster0";
const USER_COLLECTION = "user";
const TEST_COLLECTION = "test";
const QUESTION_COLLECTION = "question";
const RESULTAT_TEST_COLLECTION = "resultat_test";
const MOTIVATION_COLLECTION = "motivation";

User userData = User(id: "0", nom: "nom", prenom: "prenom", email: "email", age: 0, adresse: "adresse", role: false, id_motivation: "0", mot_de_passe: "mot_de_passe");