import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/doctor.dart';
import '../models/person.dart';
import '../models/plan.dart';
import '../models/appointment.dart';


class TodoRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Medical2024.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

Future _createDB(Database db, int version) async {
  await db.execute(
      'CREATE TABLE Persons(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, birthDate TEXT)');
  await db.execute(
      'CREATE TABLE Doctors(id INTEGER PRIMARY KEY AUTOINCREMENT, speciality TEXT,location TEXT,hireDate TEXT,personId INTEGER)');
  await db.execute(
      'CREATE TABLE Users(id INTEGER PRIMARY KEY AUTOINCREMENT,user TEXT, password TEXT, type TEXT, personId INTEGER)');
  await db.execute(
      'CREATE TABLE Appointments(id INTEGER PRIMARY KEY AUTOINCREMENT, nameDoctor TEXT, speciality TEXT, citeDate TEXT, citeHour TEXT,description TEXT, userId INTEGER)');
  await db.execute(
      'INSERT INTO Persons(name, birthDate) VALUES (?, ?)',
      ['admin', '00-00-0000']);
  await db.execute(
      'INSERT INTO Users(user, password, type,personId) VALUES (?, ?, ?, ?)',
      ['admin', 'admin', 'Admin', 1]);

      
}


Future<void> insertPersonUserDoctor(Person person, Doctor doctor, User user) async {
  final db = await database;
  await db.transaction((txn) async {
    // Insertar en la tabla Persons
    int personId = await txn.insert('Persons', person.toMap());

    // Preparar e insertar en la tabla Users
    Doctor newUser = Doctor(
      speciality: doctor.speciality,
      location: doctor.location,
      hireDate: doctor.hireDate,
      personId: personId,
    );
    await txn.insert('Doctors', newUser.toMap());

    // Preparar e insertar en la tabla Plans
    User newPlan = User(
      user: user.user,
      password: user.password,
      type: user.type,
      personId: personId,
    );
    await txn.insert('Users', newPlan.toMap());
  });
}

Future<void> insertPersonUserClient(Person person, User user) async {
  final db = await database;
  await db.transaction((txn) async {
    // Insertar en la tabla Persons
    int personId = await txn.insert('Persons', person.toMap());

    // Preparar e insertar en la tabla Plans
    User newPlan = User(
      user: user.user,
      password: user.password,
      type: user.type,
      personId: personId,
    );
    await txn.insert('Users', newPlan.toMap());
  });
}



Future<List<User2>> login(User user) async {
  final db = await database;
  
  var result = await db.rawQuery(
      '''
      SELECT Persons.id as id, Persons.name as name, Users.type as type 
        FROM Users ,Persons   
        WHERE Persons.id = Users.personId AND user = '${user.user}' AND password = '${user.password}'
      ''');
  
  return result.map((doctorMap) => User2.fromMap(doctorMap)).toList();
}

  
  Future insertUserD(Plan plan) async {
    final db = await database;
    int id = await db.insert('Plans', plan.toMap());
    return id;
  }

Future<List<Doctor2>> getAllDoctors() async {
  final db = await database;
  final List<Map<String, dynamic>> doctorMaps = await db.rawQuery('''
    SELECT Persons.id AS id, Persons.name AS name, 
           Doctors.speciality AS speciality, Doctors.location AS location, Persons.birthDate AS birthDate, Doctors.hireDate AS hireDate
    FROM Doctors, Persons where Doctors.personId = Persons.id
  ''');

  return doctorMaps.map((doctorMap) => Doctor2.fromMap(doctorMap)).toList();
}

  Future<List<Doctor2>> getDoctorsByFilter(String filtro) async {
    final db = await database;
    final List<Map<String, dynamic>> doctorMaps = await db.rawQuery('''
      SELECT Persons.id AS id, Persons.name AS name, 
             Doctors.speciality AS speciality, Doctors.location AS location,
             Persons.birthDate AS birthDate, Doctors.hireDate AS hireDate
      FROM Doctors, Persons WHERE Doctors.personId = Persons.id
      AND (Persons.name LIKE '%$filtro%' 
           OR Doctors.speciality LIKE '%$filtro%' 
           OR Doctors.location LIKE '%$filtro%')
    ''');

     return doctorMaps.map((doctorMap) => Doctor2.fromMap(doctorMap)).toList();
  }


  Future insertPlan(Plan plan) async {
    final db = await database;
    int id = await db.insert('Plans', plan.toMap());
    return id;
  }

  Future deletePlan(Plan plan) async {
    final db = await database;
    await db.delete('Plans', where: 'id = ?', whereArgs: [plan.id]);
  }

  Future<void> deleteAllTaskForPlan(Plan plan) async {
    final db = await database;
    await db.delete('Tasks', where: 'planId = ?', whereArgs: [plan.id]);
  }
 Future<List<Appointment>> getAppointmentsForPlan(int id ,String name) async {
    final db = await database;
    final List<Map<String, dynamic>> appointmentMaps = await db.query(
      'Appointments',
      where: 'userId = ? AND nameDoctor = ?',
      whereArgs: [id,name], 
    );
    return appointmentMaps.map((appointmentMap) => Appointment.fromMap(appointmentMap)).toList();
  }

  Future<List<Appointment>> getAppointmentsForPlanAll(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> appointmentMaps = await db.query(
      'Appointments',
      where: 'userId = ?',
      whereArgs: [id], 
    );
    return appointmentMaps.map((appointmentMap) => Appointment.fromMap(appointmentMap)).toList();
  }

    Future<List<Appointment>> getAppointmentsForPlanAllM(String name) async {
    final db = await database;
     final List<Map<String, dynamic>> appointmentMaps = await db.rawQuery('''
    SELECT Persons.name AS name, Appointments.citeDate, Appointments.citeHour, Appointments.description
           Doctors.speciality AS speciality, Doctors.location AS location, Persons.birthDate AS birthDate, Doctors.hireDate AS hireDate
    FROM Users, Persons,Appointments where Users.personId = Persons.id AND Appointments.userId = Users.id AND Doctors.AND Doctors.personId = Persons.id AND nameDoctor= '${name}'
  ''');
    return appointmentMaps.map((appointmentMap) => Appointment.fromMap(appointmentMap)).toList();
  }

  Future<int> insertAppointment(Appointment appointment) async {
    final db = await database;
    int id = await db.insert('Appointments', appointment.toMap());
    return id;
  }

  Future<void> deleteAppointment(Appointment appointment) async {
    final db = await database;
    await db.delete('Appointments', where: 'id = ?', whereArgs: [appointment.id]);
  }

}
