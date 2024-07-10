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

}
