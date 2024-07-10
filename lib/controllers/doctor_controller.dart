import 'package:sqlite_flutter_crud/models/doctor.dart';
import '../services/doctor_service.dart';

class DoctorController {
  final DoctorService _doctorService;
  DoctorController(this._doctorService);

  final _doctors2 = <Doctor2>[];

  List<Doctor2> get doctors => List.unmodifiable(_doctors2);

  Future<void> loadDoctors() async {
    try {
      _doctors2.clear();
      final loadedDoctors = await _doctorService.getDoctors();
      if (loadedDoctors.isNotEmpty) _doctors2.addAll(loadedDoctors);
    } catch (e) {
      throw Exception("Error al cargar los medicos: $e");
    }
  }

Future<void> loadFilter(String filtro) async {
  try {
    _doctors2.clear();
    final loadedDoctors = await _doctorService.getDoctorsFilter(filtro);
    if (loadedDoctors.isNotEmpty)  {
      _doctors2.addAll(loadedDoctors);
    }
  } catch (e) {
    throw Exception("Error al cargar los médicos: $e");
  }
}



/*
  Future<void> addPlan(String name) async {
    if (name.isEmpty) name = "Plan";
    name = ListUtils.checkForDuplicates(plans.map((plan) => plan.name), name);
    try {
      int id = await _planService.addPlan(Plan(name: name));
      _plans.add(Plan(id: id, name: name));
    } catch (e) {
      throw Exception("Error al añadir el plan: $e");
    }
  }

  Future<void> deletePlan(Plan plan) async {
    try {
      await _planService.deletePlan(plan);
    } catch (e) {
      throw Exception('Error al eliminar el plan: $e');
    } finally {
      _plans.removeWhere((item) => item.id == plan.id);
    }
  }
*/}
