import 'package:dareyou/models/user_profile.dart';
import 'dart:async';
import 'dart:math';

class UserProfileRepository {
  Future<List<UserProfile>> getUsers() async {
    int nummberOfUsers = 5;
    var users = await getRandomUsers(nummberOfUsers);
    return users;
  }

  // function to return one user from users list
  Future<UserProfile> getUserProfile() async {
    int nummberOfUsers = 1;
    var users = await getRandomUsers(nummberOfUsers);
    return users[0];
  }
}

Future<List<UserProfile>> getRandomUsers(int nummberOfUsers) async {
  // simulate a delay of 1 second
  await Future.delayed(const Duration(seconds: 1));

  // generate a list of random users
  final random = Random();
  final users = List.generate(
    nummberOfUsers,
    (index) => UserProfile(
      id: index.toString(),
      firstName: 'User${index + 1}',
      lastName: 'Lastname${index + 1}',
      email: 'user${index + 1}@example.com',
      password: 'password${index + 1}',
      gender: Random().nextInt(2) == 0 ? false : true,
      profileImageURL: 'https://picsum.photos/id/${random.nextInt(1000)}/200/200',
      createdAt: DateTime.now().subtract(Duration(days: random.nextInt(365))),
      updatedAt: DateTime.now(),
    ),
  );

  return users;
}
