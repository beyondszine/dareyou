import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
CollectionReference users = firestore.collection('users');

Future<Map<String, dynamic>> getFirestoreUserById(String id) async {
  try {
    DocumentSnapshot documentSnapshot = await users.doc(id).get();
    return documentSnapshot.data() as Map<String, dynamic>;
  } catch (e) {
    debugPrint(e.toString());
    rethrow;
  }
}

Future<void> updateFirestoreUserById(String id, Map<String, dynamic> updateJson) async {
  try {
    await users.doc(id).update(updateJson);
  } catch (e) {
    debugPrint(e.toString());
    rethrow;
  }
}

Future<void> createFirestoreUser(Map<String, dynamic> data) async {
  try {
    bool userExists = await checkDocumentExists(users, data["id"]);
    if(!userExists){
      await users.doc(data['id']).set(data);
    }
  } catch (e) {
    debugPrint(e.toString());
    rethrow;
  }
}

Future<void> logout() async {
  try {
    await firebaseAuth.signOut();
  } catch (e) {
    debugPrint(e.toString());
    rethrow;
  }
}

Future<bool> checkDocumentExists(collection, id) async {
  DocumentSnapshot documentSnapshot = await users.doc(id).get();

  return documentSnapshot.exists;
}
