import 'dart:io';

import 'package:dareyou/models/user_profile.dart';
import 'package:dareyou/repositories/user_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dareyou/assets/consts.dart';
import 'package:dareyou/screens/profile/bloc/profile_bloc.dart';
// import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _imageFile;
  final UserProfileBloc userProfileBloc = UserProfileBloc(userRepository: UserProfileRepository());
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _countryController = TextEditingController();
    userProfileBloc.add(UserProfileLoadStarted());
    // UserProfileRepository().getUserProfile().then((userProfile) => {tempUserProfile = userProfile});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
      bloc: userProfileBloc,
      listener: (context, UserProfileState state) {
        debugPrint('UserProfileScreen: listener: state: $state');
        if (state is UserProfileLoadSuccess) {
          _nameController.text = state.userProfile.firstName;
          _ageController.text = state.userProfile.lastName.toString();
          _countryController.text = state.userProfile.email;
        }
      },
      builder: (BuildContext context, UserProfileState state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(userProfileAppBarText),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showImagePicker(context);
                    },
                    child: kIsWeb
                        ? CircleAvatar(
                            radius: 64.0,
                            backgroundImage:
                                _imageFile != null ? NetworkImage(_imageFile!.path) : null,
                            child: _imageFile == null ? const Icon(Icons.camera_alt) : null,
                          )
                        : CircleAvatar(
                            radius: 64.0,
                            backgroundImage:
                                _imageFile != null ? FileImage(File(_imageFile!.path)) : null,
                            child: _imageFile == null ? const Icon(Icons.camera_alt) : null,
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                ),
                // DropdownButtonFormField<String>(
                //   value: state.gender,
                //   onChanged: (value) {
                //     BlocProvider.of<UserProfileBloc>(context).add(SexChanged(sex: value!));
                //   },
                //   items: <String>['Male', 'Female'].map((String sex) {
                //     return DropdownMenuItem<String>(
                //       value: sex,
                //       child: Text(sex),
                //     );
                //   }).toList(),
                //   decoration: const InputDecoration(
                //     labelText: 'Sex',
                //   ),
                // ),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your country';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          debugPrint("Saving user profile");
                          debugPrint("Name: ${_nameController.text}");
                          debugPrint("Age: ${_ageController.text}");
                          debugPrint("Country: ${_countryController.text}");

                          // BlocProvider.of<UserProfileBloc>(context).add(UserProfileSaved(
                          //   name: _nameController.text,
                          //   age: int.parse(_ageController.text),
                          //   country: _countryController.text,
                          // ));
                        }
                      },
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<UserProfileBloc>(context).add(UserProfileEditStarted());
                      },
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  debugPrint('Camera button tapped!');
                  // TODO: why is this popping done?
                  Navigator.pop(context);
                  final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
                  debugPrint('pickedFile: $pickedFile');
                  setState(() {
                    debugPrint("set state in image picker");
                    _imageFile = pickedFile;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  debugPrint('Gallery button tapped!');
                  Navigator.pop(context);
                  final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
                  debugPrint('pickedFile: $pickedFile');
                  setState(() {
                    debugPrint("set state in gallery image picker");
                    _imageFile = pickedFile;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
