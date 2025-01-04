import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/routine.dart';

class DatabaseService {
    static Database? _db;
    static final DatabaseService instance = DatabaseService._constructor();

    DatabaseService._constructor();

    Future<Database> getDatabase() async {
        if (_db != null) return _db!;

        final databaseDirPath = await getDatabasesPath();
        final databasePath = join(databaseDirPath, "master_db.db");

        _db = await openDatabase(
            databasePath,
            version: 1,
            onCreate: (db, version) async {
                await db.execute('''
                  CREATE TABLE tblRoutine (
                    routineId INTEGER PRIMARY KEY AUTOINCREMENT,
                    routineName TEXT NOT NULL
                  );
                ''');

                await db.execute('''
                  CREATE TABLE tblExercise (
                    exerciseId INTEGER PRIMARY KEY AUTOINCREMENT,
                    routineId INTEGER NOT NULL,
                    exerciseName TEXT NOT NULL,
                    weight REAL NOT NULL,
                    reps INTEGER NOT NULL,
                    FOREIGN KEY (routineId) REFERENCES tblRoutine (routineId) ON DELETE CASCADE
                  );
                ''');

                await db.execute('''
                  CREATE TABLE tblTrain (
                    routineId INTEGER NOT NULL,
                    trainDate DATE NOT NULL,
                    obs TEXT NOT NULL,
                    reps INTEGER NOT NULL,
                    weight REAL NOT NULL,
                    PRIMARY KEY (routineId, trainDate),
                    FOREIGN KEY (routineId) REFERENCES tblRoutine (routineId) ON DELETE CASCADE
                  );
                ''');
            },
        );

        return _db!;
    }

    void addRoutine(String routineName) async {
        final db = await getDatabase();
        await db.insert('tblRoutine', {'routineName': routineName});
    }

    Future<List<Routine>> getRoutines() async {
        final db = await getDatabase();
        final data = await db.query("tblRoutine");
        List<Routine> routines = data
            .map((e) =>
                Routine(id: e["routineId"] as int, name: e["routineName"] as String))
            .toList();
        return routines;
    }

    Future<int> addExerciseToRoutine(int routineId, String exerciseName, double weight, int reps) async {
        final db = await getDatabase();
        return await db.insert('tblExercise', {
            'routineId': routineId,
            'exerciseName': exerciseName,
            'weight': weight,
            'reps': reps
        });
    }

    Future<List<Map<String, dynamic>>> getExercises(int routineId) async {
        final db = await getDatabase();
        return await db.query('tblExercise', where: 'routineId = ?', whereArgs: [routineId]);
    }

    Future<int> updateExercise(int exerciseId, String exerciseName, double weight, int reps) async {
        final db = await getDatabase();
        return await db.update(
            'tblExercise',
            {
                'exerciseName': exerciseName,
                'weight': weight,
                'reps': reps
            },
            where: 'exerciseId = ?',
            whereArgs: [exerciseId]
        );
    }

    Future<int> deleteRoutine(int routineId) async {
        final db = await getDatabase();
        return await db.delete('tblRoutine', where: 'routineId = ?', whereArgs: [routineId]);
    }

    Future<int> deleteExercise(int exerciseId) async {
        final db = await getDatabase();
        return await db.delete('tblExercise', where: 'exerciseId = ?', whereArgs: [exerciseId]);
    }
}
