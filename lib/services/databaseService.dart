import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import '../constant.dart';

class MongoDatabase {
  static Db? db;
  static late DbCollection user;
  static late DbCollection test;
  static late DbCollection question;
  static late DbCollection resultatTest;
  static late DbCollection motivation;

  static connect() async {
    try {
      db = await Db.create(MONGO_CONN_URL);
      await db!.open();
      inspect(db);

      user = db!.collection(USER_COLLECTION);
      test = db!.collection(TEST_COLLECTION);
      question = db!.collection(QUESTION_COLLECTION);
      resultatTest = db!.collection(RESULTAT_TEST_COLLECTION);
      motivation = db!.collection(MOTIVATION_COLLECTION);
    } catch (e) {
      log('Connection error: ${e.toString()}');
    }
  }

  static Future<void> close() async {
    try {
      await db!.close();
    } catch (e) {
      log('Close connection error: ${e.toString()}');
    }
  }
}
