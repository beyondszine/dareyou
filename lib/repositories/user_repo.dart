import 'package:dareyou/services/firestore_utils.dart' as firestore_utils;
import 'package:flutter/foundation.dart';
import 'package:dareyou/models/user_model.dart';

class UserRepository {

  late User _currentUser;

  UserRepository() {
    _currentUser = User();
  }

  Future<void> initialize() async {
    bool userExists = await firestore_utils.checkDocumentExists(firestore_utils.users, _currentUser.id);
    if (userExists) {
      await loggin();
    } else {
      await firestore_utils.createFirestoreUser(_currentUser.toJson());
    }
  }

  Future<void> update({updateJson=const {}}) async {
    bool userExists = await firestore_utils.checkDocumentExists(firestore_utils.users, _currentUser.id);
    if (userExists) {
      Map<String, dynamic> firestoreUser = _currentUser.toJson();
      firestoreUser["_updatedAt"] = DateTime.now();
      updateJson.forEach((key, value) {
        firestoreUser[key] = updateJson[value];
      });
      _currentUser = User.fromJson(firestoreUser);
      await firestore_utils.updateFirestoreUserById(_currentUser.id, _currentUser.toJson());
    } else {
      debugPrint('User does not exists.');
    }
  }

  Future<void> delete() async {

    bool userExists = await firestore_utils.checkDocumentExists(firestore_utils.users, _currentUser.id);
    if (userExists) {
      Map<String, dynamic> firestoreUser = _currentUser.toJson();
      firestoreUser["_deleted"] = true;
      await firestore_utils.updateFirestoreUserById(_currentUser.id, _currentUser.toJson());
    } else {
      debugPrint('User does not exists.');
    }
  }

  Future<void> loggin() async {
    bool userExists = await firestore_utils.checkDocumentExists(firestore_utils.users, _currentUser.id);
    if (userExists) {
      Map<String, dynamic> firestoreUser = await firestore_utils.getFirestoreUserById(_currentUser.id);
      firestoreUser["_lastLogginAt"] = DateTime.now();
      _currentUser = User.fromJson(firestoreUser);
      await firestore_utils.updateFirestoreUserById(_currentUser.id, _currentUser.toJson());
    } else {
      debugPrint('User loggin not updated in Store!');
    }
  }

  Future<void> logout() async {
    await firestore_utils.logout();
  }

  Map<String, dynamic> getCurrentUser() {
    return _currentUser.toJson();
  }

}