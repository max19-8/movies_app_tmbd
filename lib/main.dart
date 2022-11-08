import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/library/Widgets/inherited/provider.dart';
import 'my_app.dart';
import 'my_app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
   await model.checkAuth();
   const app = MyApp();
  final widget =  Provider(model: model, child: app);
  runApp(widget);
}


