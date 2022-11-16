import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_tmbd/navigation/main_navigation.dart';
import 'loader_view_model.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderViewCubit,LoaderViewCubitState>(
      listenWhen: (prev, current) => current != LoaderViewCubitState.unknown,
      listener:(context,state){
        onLoaderViewCubitStateChange(context,state);
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }


  void onLoaderViewCubitStateChange(BuildContext context, LoaderViewCubitState state){
    final nextScreen = state == LoaderViewCubitState.authorized ? MainNavigationRouteNames.mainScreen : MainNavigationRouteNames.auth ;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}
