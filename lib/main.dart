import 'package:flutter/material.dart';
import 'package:gymapp/pages/home_page.dart';
import 'package:gymapp/services/route_generator.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
  ));
}
