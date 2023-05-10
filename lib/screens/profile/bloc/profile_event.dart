part of 'profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class UserProfileLoadStarted extends UserProfileEvent {}

class UserProfileEditStarted extends UserProfileEvent {}

class UserProfileNameChanged extends UserProfileEvent {
  final String name;

  const UserProfileNameChanged({required this.name});

  @override
  List<Object> get props => [name];
}

class UserProfileAgeChanged extends UserProfileEvent {
  final int age;

  const UserProfileAgeChanged({required this.age});

  @override
  List<Object> get props => [age];
}

class UserProfileSexChanged extends UserProfileEvent {
  final String sex;

  const UserProfileSexChanged({required this.sex});

  @override
  List<Object> get props => [sex];
}

class UserProfileCountryChanged extends UserProfileEvent {
  final String country;

  const UserProfileCountryChanged({required this.country});

  @override
  List<Object> get props => [country];
}

class UserProfileImageChanged extends UserProfileEvent {
  final File imageFile;

  const UserProfileImageChanged({required this.imageFile});

  @override
  List<Object> get props => [imageFile];
}

class UserProfileSaved extends UserProfileEvent {
  final UserProfile userProfile;

  const UserProfileSaved({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}
