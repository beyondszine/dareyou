
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
  Map<String, dynamic>? _fcmToken;

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
    this.active
  }): id = firebaseAuth.currentUser!.uid,
      email = firebaseAuth.currentUser!.email,
      mobile = firebaseAuth.currentUser!.phoneNumber,
      _deleted = false,
      _createdAt = DateTime.now(),
      _updatedAt = DateTime.now(),
      _lastLogginAt = DateTime.now(),
      _fcmToken = {};

  Map<String, dynamic>? get fcmToken {
    return _fcmToken;
  }

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
    active = json['active'];
    _deleted = json['_deleted'];
    _lastLogginAt = (json['_lastLogginAt'] as Timestamp).toDate();
    _createdAt =  (json['_createdAt'] as Timestamp).toDate();
    _updatedAt = (json['_updatedAt'] as Timestamp).toDate();
    _fcmToken = json['_fcmToken'];
  }

  Map<String, dynamic> toJson({List<String> fields= const []}) {
    Map<String, dynamic> userJson = {};
    userJson['id'] = id;
    userJson['name'] = name;
    userJson['email'] = email;
    userJson['mobile'] = mobile;
    userJson['bio'] = bio;
    userJson['age'] = age;
    userJson['address'] = address;
    userJson['country'] = country;
    userJson['state'] = state;
    userJson['city'] = city;
    userJson['pincode'] = pincode;
    userJson['language'] = language;
    userJson['gender'] = gender;
    userJson['image'] = image;
    userJson['active'] = active;

    if(fields.isNotEmpty) {
      Map<String, dynamic> extractJson = {};

      for(final field in fields) {
        extractJson[field] = userJson[field];
      }

      return extractJson;
    } else {
      return userJson;
    }
  }

  void updateFcmToken() {
    _fcmToken = {};
  }
}
