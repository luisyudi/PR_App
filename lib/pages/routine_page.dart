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
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
        child: Column(
          children: _loadExercises(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Valor para peso inválido")));
                              return;
                            }

                            final reps = int.tryParse(textReps.text);
                            if (reps == null || reps <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Número de repetições inválido")));
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
                    exercise: exercise,
                    database: widget.database,
                    onUpdate: (){
                      setState(() {

                      });
                    }
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
  final DatabaseService database;
  final VoidCallback onUpdate;

  const ExerciseWidget({required this.exercise, required this.database, required this.onUpdate, super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Card(
        color: Colors.grey[800],
        margin: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
        child: Container(
          width: screenWidth * 0.9,
          height: 120,
          padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    exercise.exerciseName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () => _editExercise(context),
                      icon: Icon(
                          Icons.edit,
                          color: Colors.white,

                      )
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  _labelWidget("Peso: ${(exercise.weight % 1 == 0)
                      ? exercise.weight.toInt().toString()
                      : exercise.weight.toString()} kg"),
                ],
              ),
              Row(
                children: [
                  _labelWidget('Repetições: ${exercise.reps}'),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  void _editExercise(BuildContext context) {
    TextEditingController txtName = TextEditingController();
    TextEditingController txtWeight = TextEditingController();
    TextEditingController txtReps = TextEditingController();

    txtName.text = exercise.exerciseName;

    txtWeight.text = (exercise.weight % 1 == 0)
        ? exercise.weight.toInt().toString()
        : exercise.weight.toString();

    txtReps.text = exercise.reps.toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.grey[900],
          child: SizedBox(
            width: 800,
            height: 400,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Editar Exercício',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: txtName,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      border: UnderlineInputBorder()
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      _editValueButtonWidget(-5, txtWeight),
                      _editValueButtonWidget(-1, txtWeight),
                      Flexible(
                        child: TextField(
                          maxLength: 5,
                          controller: txtWeight,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.transparent,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _editValueButtonWidget(1, txtWeight),
                      _editValueButtonWidget(5, txtWeight),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Spacer(),
                      _editValueButtonWidget(-1, txtReps),
                      Container(
                        width: 70,
                        child: TextField(
                          maxLength: 3,
                          controller: txtReps,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.transparent,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _editValueButtonWidget(1, txtReps),
                      Spacer()
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
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
                          if (txtName.text == "" || txtWeight.text == "" || txtReps.text == "") return;

                          if(
                          txtName.text == exercise.exerciseName
                              && txtWeight.text == exercise.weight.toString()
                              && txtReps.text == exercise.reps.toString()
                          ) {
                            return;
                          }

                          final weight = double.tryParse(txtWeight.text);

                          if (weight == null || weight <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Valor para peso inválido")));
                            return;
                          }

                          final reps = int.tryParse(txtReps.text);
                          if (reps == null || reps <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Número de repetições inválido")));
                            return;
                          }

                          database.updateExercise(exercise.exerciseId, txtName.text, weight, reps);
                          onUpdate();
                          Navigator.of(context).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red,
                            backgroundColor: Colors.red,
                            shape: ContinuousRectangleBorder(),
                            overlayColor: Colors.red
                        ),
                        child: Text(
                          'Salvar',
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

  Widget _labelWidget(String text){
    return Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
    );
  }

  Widget _editValueButtonWidget(int value, TextEditingController controller){
    return TextButton(
      onPressed: () {
        double num = double.parse(controller.text) + value;
        if (num < 0){
          controller.text = '0';
          return;
        }

        controller.text =  (num % 1 == 0)
            ? num.toInt().toString()
            : num.toString();
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(40, 40),
        backgroundColor: Colors.grey[800],
        shape: CircleBorder(),
      ),
      child: Text(
        (value > 0) ? '+$value': value.toString(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}
