import 'package:flutter/material.dart';
import 'package:gymapp/services/database_service.dart';

import '../models/routine.dart';

class RoutinePage extends StatefulWidget {
  final Routine routine;
  final DatabaseService database = DatabaseService.instance;

  RoutinePage({required this.routine, Key? key}) : super(key: key);

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[800],
        title: Text(
          widget.routine.name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == 'Deletar Treino') {
                _deleteRoutine();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Deletar Treino'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO: add new exercises
        },
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _deleteRoutine() async {
    // Confirmação do usuário antes de deletar
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text(
            'Deletar Treino',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Você tem certeza que deseja deletar este treino?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Deletar',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await widget.database.deleteRoutine(widget.routine.id); // Deleta do banco
      Navigator.of(context).pop(true); // Volta para a tela anterior
    }
  }
}
