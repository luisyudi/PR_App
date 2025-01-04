import 'package:flutter/material.dart';
import 'package:gymapp/models/exercise.dart';
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
            fontWeight: FontWeight.bold
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
      body: Column(
        children: _loadExercises(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO: add new exercises
          _newExercise(context);
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

  void _newExercise(BuildContext context){
    TextEditingController textName = TextEditingController();
    TextEditingController textWeight = TextEditingController();
    TextEditingController textReps = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.grey[900],
          child: SizedBox(
            width: 800,
            height: 360,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Adicionar novo exercício',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: textName,
                    decoration: InputDecoration(
                      labelText: 'Nome do Exercício',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[800]!),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: textWeight,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Peso',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[800]!),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: textReps,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Número de Repetições',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[800]!),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                            shape: ContinuousRectangleBorder(),
                            overlayColor: Colors.red
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                            if (textName.text == "" || textWeight.text == "" || textReps.text == "") return;

                            final weight = double.tryParse(textWeight.text);

                            if (weight == null || weight <= 0) {
                              print("Valor para peso inválido");
                              return;
                            }

                            final reps = int.tryParse(textReps.text);
                            if (reps == null || reps <= 0) {
                              print("Número de repetições inválido");
                              return;
                            }

                            widget.database.addExerciseToRoutine(widget.routine.id, textName.text, weight, reps);
                            setState(() {

                            });
                            Navigator.of(context).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red,
                            backgroundColor: Colors.red,
                            shape: ContinuousRectangleBorder(),
                            overlayColor: Colors.red
                        ),
                        child: Text(
                          'Criar',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _loadExercises(){
    return [
      FutureBuilder<List<Exercise>>(
        future: widget.database.getExercises(widget.routine.id),
        builder: (BuildContext context, AsyncSnapshot<List<Exercise>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os exercícios'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum exercício cadastrado', style: TextStyle(color: Colors.white)));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final exercise = snapshot.data![index];
                return ExerciseWidget(
                    exercise
                );
              },
            );
          }
        },
      )
    ];
  }
}

class ExerciseWidget extends StatelessWidget {
  final Exercise exercise;

  const ExerciseWidget(this.exercise,{super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Card(
        color: Colors.grey[800],
        margin: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
        child: Container(
          width: screenWidth * 0.9,
          height: 180,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    exercise.exerciseName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: Icon(
                          Icons.edit,
                          color: Colors.white,

                      )
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  TextButton(onPressed: (){}, child: Text('a')),
                  TextButton(onPressed: (){}, child: Text('b')),
                  Container(
                    width: 40,
                    height: 40,
                    child: TextField(
                      //controller: textController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[800]!),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(onPressed: (){}, child: Text('c')),
                  TextButton(onPressed: (){}, child: Text('d')),
                ],
              ),
              Row(
                children: [
                  TextButton(onPressed: (){}, child: Text('a')),
                  //TextField(),
                  TextButton(onPressed: (){}, child: Text('b')),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
