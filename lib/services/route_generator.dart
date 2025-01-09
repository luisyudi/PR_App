import 'package:flutter/material.dart';
import 'package:gymapp/pages/home_page.dart';

import '../models/routine.dart';
import '../pages/routine_page.dart';

class RouteGenerator{
    static Route<dynamic> generateRoute(RouteSettings settings){
        final args = settings.arguments;

        switch(settings.name){
          case '/':
              return MaterialPageRoute(builder: (_) => Home());
          case '/routine':
            if (args is Routine){
                return MaterialPageRoute(builder: (_) => RoutinePage(routine: args));
            }
          default:
            return _errorRoute("Rota nao encontrada");
        }
        return _errorRoute("Rota nao encontrada");
    }


    static Route<dynamic> _errorRoute(String message) {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text("Error")),
          body: Center(
            child: Text(
              message,
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
        ),
      );
    }
}

