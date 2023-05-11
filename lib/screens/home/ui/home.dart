import 'package:dareyou/assets/consts.dart';
import 'package:dareyou/screens/home/bloc/home_bloc.dart';
import 'package:dareyou/screens/login/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:dareyou/utils/firestore_utils.dart' as firestore_utils;
import 'package:dareyou/data/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  HomeBloc homeBloc = HomeBloc();

  @override
  void initState(){
    debugPrint("HomeScreen: initState");
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
        buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        switch (state.runtimeType) {
          case HomeUserNotSignedInState:
            debugPrint(logOutSnackBarMessage);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(userNotRegisteredText)),
            );
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
            break;
          case HomeUserSignedOutState:
            debugPrint(logOutSnackBarMessage);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
            break;
          default:break;
        }
      },
      builder: (context, state) {
        switch(state.runtimeType) {
          case HomeUserSignedInState:
            final HomeUserSignedInState homeUserRegisteredState = state as HomeUserSignedInState;
            return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      homeBloc.add(HomeUserLogoutEvent(currentUser: homeUserRegisteredState.currentUser));
                    },
                    icon: const Icon(Icons.logout_outlined)
                  ),
                ],
              ),
              body: Text("${homeUserRegisteredState.currentUser})")
            ); 
          default:
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()),
            ); 
        }
      },
    );
  }
}
