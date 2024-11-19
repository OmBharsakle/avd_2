import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FitnessServices {
  FitnessServices._();

  static FitnessServices fitnessServices = FitnessServices._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFitnessToFireStore(int id, String workoutName, String duration,
      String date, String type) async {
    await _firestore.collection("fitness").doc(id.toString()).set({
      'id': id,
      'workoutName' : workoutName,
      'duration' : duration,
      'date' : date,
      'type' : type,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readFitnessFromFireStore() {
    return _firestore.collection("fitness").snapshots();
  }

  Future<void> deleteFitnessFromFireStore(int id) async {
    await _firestore.collection("fitness").doc(id.toString()).delete();
  }

  Future<void> updateFitnessInFireStore(int id, String workoutName, String duration,
      String date, String type) async {
    await _firestore.collection("fitness").doc(id.toString()).update({
      'id': id,
      'workoutName' : workoutName,
      'duration' : duration,
      'date' : date,
      'type' : type,
    });
  }

  Future<void> loginPage(String emailAddress,String password)
  async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  Future<void> signFitnessAccount(String emailAddress,String password)
  async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

}

