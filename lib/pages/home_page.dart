import 'package:flutter/material.dart';
import 'package:gymapp/services/database_service.dart';
import '../models/routine.dart';
import 'routine.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseService _database = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
            'Treinos',
            style: TextStyle(
                color: Colors.white,
                fontSize: 36,
            ),
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: _routineList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newRoutine(context),
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }

  void newRoutine(BuildContext context){
    TextEditingController textController = TextEditingController();
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
            height: 230,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Criar novo Treino',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: 'Nome do Treino',
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
                  SizedBox(height: 30),
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
                          String name = textController.text;
                          if(name == "") return;
                          _database.addRoutine(name);
                          textController.text = "";
                          setState((){});
                          Navigator.of(context).pop();
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

  List<Widget> _routineList(){
    return [
      FutureBuilder<List<Routine>>(
        future: _database.getRoutines(),
        builder: (BuildContext context, AsyncSnapshot<List<Routine>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar as rotinas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma rotina cadastrada', style: TextStyle(color: Colors.white)));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final routine = snapshot.data![index];
                return RoutineWidget(
                  id: routine.id,
                  name: routine.name,
                  onDelete: () {
                    setState(() {
                    });
                  },
                );
              },
            );
          }
        },
      ),
    ];
  }
}


class RoutineWidget extends StatelessWidget {
  final int id;
  final String name;
  final VoidCallback onDelete;

  RoutineWidget({required this.id, required this.name, required this.onDelete,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Card(
        color: Colors.grey[800],
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          width: screenWidth * 0.9,
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () async {
                  Routine routine = Routine(id: id, name: name);
                  final bool? s = await Navigator.of(context).pushNamed(
                    '/routine',
                    arguments: routine,
                  ) as bool?;
                  if (s == true) {
                    onDelete();
                  }
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith( //Remove default click effects
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.grey[800],
        unselectedFontSize: 15,
        selectedFontSize: 15,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        iconSize: 32.0,
        currentIndex: _selectedIndex,
        onTap: _itemTapped,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_sharp),
            label: 'Treinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: 'Estatísticas',
          ),
        ],
      ),
    );
  }
}
