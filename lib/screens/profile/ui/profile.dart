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
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as path;
// import 'dart:io' as io;
// import 'package:universal_html/html.dart' as html;

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
  late TextEditingController _userNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
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
          _userNameController.text = state.userProfile.userName;
          _phoneController.text = state.userProfile.phoneno.toString();
          _emailController.text = state.userProfile.email.toString();
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
                  controller: _userNameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your contact number';
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
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        final String downloadUrl;
                        if (_formKey.currentState!.validate()) {
                          debugPrint("Saving user profile");
                          String fileName = path.basename(_imageFile!.path);
                          debugPrint("Filename for user profile pic is $fileName");
                          final Reference storageReference =
                              FirebaseStorage.instance.ref().child(fileName);
                          if (!kIsWeb) {
                            downloadUrl = await storageReference
                                .putFile(File(_imageFile!.path))
                                .then((p0) => storageReference.getDownloadURL());
                            // .then((url) {
                            //   debugPrint("Download URL for user profile pic is $url");
                            // });
                          } else {
                            debugPrint("WEB platform detected");
                            var data = await _imageFile!.readAsBytes();
                            // debugPrint("Data for user profile pic is ${data.toString()}");
                            await storageReference.putData(data);
                            var url = await storageReference.getDownloadURL();
                            debugPrint("Download URL for user profile pic is $url");
                            downloadUrl = url;
                          }
                          UserProfile up = UserProfile(
                              userName: _userNameController.text,
                              phoneno: _phoneController.text,
                              email: _emailController.text,
                              gender: null,
                              profileImageURL: downloadUrl,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now());
                          debugPrint("Saving user profile: ${up.toJson().toString()}");
                          // BlocProvider.of<UserProfileBloc>(context)
                          //     .add(UserProfileSaved(userProfile: up));
                        }
                      },
                      child: const Text('Save'),
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
