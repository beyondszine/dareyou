import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dareyou/utils/firestore_utils.dart' as firestore_utils;
import 'package:flutter/foundation.dart';

class User {

  final String id;
  String? fediverseId;
  String? name;
  String? email;
  String? bio;
  int? age;
  String? address;
  String? country;
  String? state;
  String? city;
  int? pincode;
  String? language;
  String? gender;
  String? mobile;
  String? image;
  bool? _deleted = false;
  DateTime? _lastLogginAt;
  DateTime? _createdAt;
  DateTime? _updatedAt;
  bool? active;
  String? fcmToken;

  User({
    this.fediverseId,
    this.name,
    this.bio,
    this.age,
    this.address,
    this.country,
    this.state,
    this.city,
    this.pincode,
    this.language,
    this.gender,
    this.image,
    this.active,
    this.fcmToken
  }): id = FirebaseAuth.instance.currentUser!.uid,
      email = FirebaseAuth.instance.currentUser!.email,
      mobile = FirebaseAuth.instance.currentUser!.phoneNumber,
      _createdAt = DateTime.now(),
      _updatedAt = DateTime.now(),
      _lastLogginAt = DateTime.now();

  // create user object from Map<String, dynamic> data.
  User.fromJson(Map<String, dynamic> json)
  : id=FirebaseAuth.instance.currentUser!.uid {
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    bio = json['bio'];
    age = json['age'];
    address = json['address'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    language = json['language'];
    gender = json['gender'];
    image = json['image'];
    _deleted = json['_deleted'];
    _lastLogginAt = (json['_lastLogginAt'] as Timestamp).toDate();
    _createdAt =  (json['_createdAt'] as Timestamp).toDate();
    _updatedAt = (json['_updatedAt'] as Timestamp).toDate();
    active = json['active'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['bio'] = bio;
    data['age'] = age;
    data['address'] = address;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['pincode'] = pincode;
    data['language'] = language;
    data['gender'] = gender;
    data['image'] = image;
    data['_deleted'] = _deleted;
    data['_lastLogginAt'] = _lastLogginAt;
    data['_createdAt'] = _createdAt;
    data['_updatedAt'] = _updatedAt;
    data['active'] = active;
    data['fcmToken'] = fcmToken;

    return data;
  }

  // create a user in firestore user collection from the user object.
  Future<bool> create() async {
    // get the user document.
    DocumentSnapshot? documentSnapshot = await firestore_utils.getFirestoreUserById(id);
    // check if the document exists.
    if (documentSnapshot != null && documentSnapshot.exists) {
      // return false.
      debugPrint('User already exists.');
      return false;
    } else {
      // create the user document.
      await firestore_utils.createFirestoreUser(toJson());
      // return true.
      return true;
    }
  }

  // update the user in firestore user collection from the user object.
  Future<bool> update({updateJson=const {}}) async {
    // get the user document.
    DocumentSnapshot documentSnapshot = await firestore_utils.getFirestoreUserById(id) as DocumentSnapshot;
    // check if the document exists.
    if (documentSnapshot.exists) {
      // update the user document.
      _updatedAt = DateTime.now();
      await firestore_utils.updateFirestoreUserById(id, toJson());
      // return true.
      return true;
    } else {
      // return false.
      debugPrint('User does not exists.');
      return false;
    }
  }

  // delete the user in firestore user collection from the user object.
  Future<bool> delete() async {
    // get the user document.
    Map<String, dynamic>? documentSnapshot = firestore_utils.getFirestoreUserById(id) as Map<String, dynamic>?;
    // check if the document exists.
    if (documentSnapshot != null) {
      // delete the user document.
      _deleted = true;
      _updatedAt = DateTime.now();
      await firestore_utils.updateFirestoreUserById(id, toJson());
      // return true.
      return true;
    } else {
      // return false.
      debugPrint('User does not exists.');
      return false;
    }
  }

  Future<void> loggin() async {
    DocumentSnapshot documentSnapshot = await firestore_utils.getFirestoreUserById(id) as DocumentSnapshot;
    if (documentSnapshot.exists) {
      // update the user document.
      _lastLogginAt = DateTime.now();
      await firestore_utils.updateFirestoreUserById(id, toJson());
    } else {
      // return false.
      debugPrint('User loggin not updated in Store!');
    }

  }

  // logout user from firebase auth.
  Future<void> logout() async {
    await firestore_utils.logout();
  }
}
