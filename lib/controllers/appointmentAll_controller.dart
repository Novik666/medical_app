import 'package:sqlite_flutter_crud/models/doctor.dart';
import 'package:sqlite_flutter_crud/models/user.dart';
import '../models/appointment.dart';
import '../services/appointmentAll_service.dart';

class AppointmentAllController {
  final User2 user2;
  final AppointmentAllService _appointmentAllService;

  AppointmentAllController(this.user2, this._appointmentAllService);

  final _appointmentAlls = <Appointment>[];

  List<Appointment> get appointmentAlls => List.unmodifiable(_appointmentAlls);


  Future<void> loadAppointmentAll(int id) async {
    try {
      _appointmentAlls.clear();
      final loadedAppointmentAlls = await _appointmentAllService.getAppointmentAllsAll(id);
      if (loadedAppointmentAlls.isNotEmpty) {
        _appointmentAlls.addAll(loadedAppointmentAlls);
      }
    } catch (e) {
      throw Exception("Error al cargar las tareas: $e");
    }
  }

    Future<void> loadAppointmentAllM(String name) async {
    try {
      _appointmentAlls.clear();
      final loadedAppointmentAlls = await _appointmentAllService.getAppointmentAllsAllM(name);
      if (loadedAppointmentAlls.isNotEmpty) {
        _appointmentAlls.addAll(loadedAppointmentAlls);
      }
    } catch (e) {
      throw Exception("Error al cargar las tareas: $e");
    }
  }


  Future<void> deleteAppointmentAll(Appointment appointment) async {
    try {
      await _appointmentAllService.deleteAppointmentAll(appointment);
      
    } catch (e) {
      throw Exception('Error al eliminar la cita: $e');
    } finally{
      _appointmentAlls.removeWhere((item) => item.id == appointment.id);
    }
  }




}

