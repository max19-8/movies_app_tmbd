import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/di/di_container.dart';

abstract class AppFactory{
  Widget makeApp();
}
final appFactory = makeFactory();

void main()  {
  final app = appFactory.makeApp();
  runApp(app);
}


