// Write a class FirestoreUtils that shall have the following:
// 1.  with a static method getFirestoreInstance() that returns a Firestore instance.
// 2.  with a static method getCollection() that returns a CollectionReference.
// 3. with a static method getDocument() that returns a DocumentReference.
// 4. with a static method getFirebaseAuthInstance() that returns a FirebaseAuth instance.
// 5. with a static method getFirebaseUser() that returns a User instance.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dareyou/data/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
CollectionReference users = firestore.collection('users');

// check if the user is already registered with firebase auth or not.
Future<User?> getFirestoreUser() async {
  // return a user object from firestore that has the given id.
  // get the firestore instance.
  // put the below line in try catch block and return null if there is an error.
  String id = firebaseAuth.currentUser!.uid;
  try {
      // get the user document.
    DocumentReference docRef = firestore.collection('users').doc(id);
    DocumentSnapshot documentSnapshot = await docRef.get();
    // check if the document exists.
    if (documentSnapshot.exists) {
      // return the user object.
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      User currentUser = User.fromJson(data);
      currentUser.loggin();
      return currentUser;
    } else {
      User newUser = User();
      await newUser.create();
      return newUser;
    }
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}

Future<DocumentSnapshot?> getFirestoreUserById(String id) async {
  try {
    // get the user document.
    DocumentSnapshot documentSnapshot = await firestore.collection('users').doc(id).get();
    // check if the document exists.
    return documentSnapshot;
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}

Future<void> updateFirestoreUserById(String id, Map<String, dynamic> updateJson) async {
  try {
    // get the user document.
    await firestore.collection('users').doc(id).update(updateJson);
    // check if the document exists.
    
  } catch (e) {
    debugPrint(e.toString());
  }
}

//create firestoreuser by json data
Future<void> createFirestoreUser(Map<String, dynamic> data) async {
  try {
    // get the user document.
    await firestore.collection('users').doc(data['id']).set(data);
    // check if the document exists.
    
  } catch (e) {
    debugPrint(e.toString());
  }
}

// create a method for logout user
Future<void> logout() async {
  try {
    await firebaseAuth.signOut();
  } catch (e) {
    debugPrint(e.toString());
  }
}
