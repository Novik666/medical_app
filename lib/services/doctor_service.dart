import 'package:sqlite_flutter_crud/models/doctor.dart';
import '../models/plan.dart';
import '../repositories/todo_repository.dart';

class DoctorService {
  final TodoRepository _todoRepository;

  DoctorService(this._todoRepository);

  Future<List<Doctor2>> getDoctors() async {
    return await _todoRepository.getAllDoctors();
  }

  Future<List<Doctor2>> getDoctorsFilter(String filtro) async {
    return await _todoRepository.getDoctorsByFilter(filtro);
  }


  Future<int> addPlan(Plan plan) async {
    return await _todoRepository.insertPlan(plan);
  }

  Future<void> deletePlan(Plan plan) async {
    await _todoRepository.deleteAllTaskForPlan(plan);
    await _todoRepository.deletePlan(plan);
  }
}


