
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dareyou/services/firestore_utils.dart';

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
  }): id = firebaseAuth.currentUser!.uid,
      email = firebaseAuth.currentUser!.email,
      mobile = firebaseAuth.currentUser!.phoneNumber,
      _createdAt = DateTime.now(),
      _updatedAt = DateTime.now(),
      _lastLogginAt = DateTime.now();

  // create user object from Map<String, dynamic> data.
  User.fromJson(Map<String, dynamic> json)
  : id = json["id"] {
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

  Map<String, dynamic> extractFields({List<String> fields= const []}) {
    Map<String, dynamic> userJson = toJson();
    Map<String, dynamic> extractJson = {};

    for(final field in fields) {
      extractJson[field] = userJson[field];
    }

    return extractJson;
  }
}
