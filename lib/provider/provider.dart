//provider
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../database/helper.dart';
import '../modal/fitness.dart';
import '../services/services.dart';

class FitnessProvider extends ChangeNotifier {
  List fitnessList = [];
  List<FitnessModal> fitnessModal = [];
  List<FitnessModal> fitnessCloudList = [];
  var workoutName = TextEditingController();
  var workoutDuration = TextEditingController();
  var workoutType = TextEditingController();
  var txtId = TextEditingController();
  var workoutDate = TextEditingController();
  String date = '';
  int id = 1;

  Future<void> signAccount(String emailAddress,String password)
  async {
    await FitnessServices.fitnessServices.signFitnessAccount(emailAddress, password);
    notifyListeners();
  }

  Future<void> loginpagemy(String emailAddress,String password)
  async {
    await FitnessServices.fitnessServices.loginPage(emailAddress, password);
    notifyListeners();
  }

  Future<void> initDatabase() async {
    await DatabaseHelper.databaseHelper.initDatabase();
  }

  // Sync Firestore data to local SQLite with update or insert logic
  Future<void> syncCloudToLocal() async {
    try {
      final snapshot =
      await FitnessServices.fitnessServices.readFitnessFromFireStore().first;
      final cloudFitness = snapshot.docs.map((doc) {
        final data = doc.data();
        return FitnessModal(id: int.parse(data['id'].toString()), workoutName: data['workoutName'], duration: data["duration"], date: data['date'], type: data['type']);
      }).toList();

      for (var fitness in cloudFitness) {
        bool exists = await DatabaseHelper.databaseHelper.fitnessExists(fitness.id);
        if (exists) {
          await DatabaseHelper.databaseHelper.updateFitness(
            fitness.id,
            fitness.workoutName,
            fitness.duration,
            fitness.date,
            fitness.type,
          );
        } else {
          await DatabaseHelper.databaseHelper.addFitnessToDatabase(
            fitness.id,
            fitness.workoutName,
            fitness.duration,
            fitness.date,
            fitness.type,
          );
        }
      }
      await readDataFromDatabase();
      notifyListeners();
    } catch (e) {
      debugPrint("Error syncing data: $e");
    }
  }

  Future<void> addFitnessDatabase(int id, String workoutName, String duration,
      String date, String type) async {
    await DatabaseHelper.databaseHelper.addFitnessToDatabase(
      id,
      workoutName,
      duration,
      date,
      type,
    );
    toMap(
      FitnessModal(
        id: id,
        workoutName : workoutName,
        duration : duration,
        date: date,
        type : type,
      ),
    );

    readDataFromDatabase();
    clearAllVar();
    notifyListeners();
  }

  Future<void> addFitnessFireStore(FitnessModal data) async {
    await FitnessServices.fitnessServices.addFitnessToFireStore(
      data.id,
      data.workoutName,
      data.duration,
      data.date,
      data.type,
    );
  }

  Future<void> updateDataFromFirestore(FitnessModal data) async {
    await FitnessServices.fitnessServices.updateFitnessInFireStore(
      data.id,
      data.workoutName,
      data.duration,
      data.date,
      data.type,
    );
  }

  Future<void> deleteDataFromFireStore(int id) async {
    await FitnessServices.fitnessServices.deleteFitnessFromFireStore(id);
  }

  void clearAllVar() {
    workoutType.clear();
    workoutDuration.clear();
    workoutName.clear();
    date = '';
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readDataFromFireStore() {
    return FitnessServices.fitnessServices.readFitnessFromFireStore();
  }

  Future<List<Map<String, Object?>>> readDataFromDatabase() async {
    String title = valueSearch;
    String cat = catSet;

    // notifyListeners();
    return fitnessList = await DatabaseHelper.databaseHelper.readAllFitness(title,cat);
  }

  Future<void> updateFitnessInDatabase(int id, String title, String content,
      String date, String category) async {
    await DatabaseHelper.databaseHelper.updateFitness(
      id,
      title,
      content,
      date,
      category,
    );
    clearAllVar();
    notifyListeners();
  }

  Future<void> deleteFitnessInDatabase(int id) async {
    await DatabaseHelper.databaseHelper.deleteFitness(id);
    notifyListeners();
  }

  FitnessProvider() {
    initDatabase();
  }
  String valueSearch = '';
  String catSet = '';

  void readSearch(String value,String cat)
  {
    valueSearch = value;
    catSet = cat;
    readDataFromDatabase();
    notifyListeners();
  }

}
