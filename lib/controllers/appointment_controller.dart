import 'package:sqlite_flutter_crud/models/doctor.dart';
import 'package:sqlite_flutter_crud/models/user.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';

class AppointmentController {
  final Doctor2 doctor2;
  final AppointmentService _appointmentService;

  AppointmentController(this.doctor2, this._appointmentService);

  final _appointments = <Appointment>[];

  List<Appointment> get appointments => List.unmodifiable(_appointments);


  Future<void> loadAppointmentAll(int id) async {
    try {
      _appointments.clear();
      final loadedAppointments = await _appointmentService.getAppointmentsAll(id);
      if (loadedAppointments.isNotEmpty) {
        _appointments.addAll(loadedAppointments);
      }
    } catch (e) {
      throw Exception("Error al cargar las tareas: $e");
    }
  }

  Future<void> loadAppointment(int id,String name) async {
    try {
      _appointments.clear();
      final loadedAppointments = await _appointmentService.getAppointments(id, name);
      if (loadedAppointments.isNotEmpty) {
        _appointments.addAll(loadedAppointments);
      }
    } catch (e) {
      throw Exception("Error al cargar las tareas: $e");
    }
  }




  Future<void> addAppointment(Appointment newAppointment) async {
    try {
      await _appointmentService.addAppointment(newAppointment);
      _appointments.add(Appointment(
        nameDoctor: newAppointment.nameDoctor,
        speciality: newAppointment.speciality,
        citeDate: newAppointment.citeDate,
        citeHour: newAppointment.citeHour,
        description: newAppointment.description,
        userId: newAppointment.userId,
      ));
    } catch (e) {
      throw Exception("Error al añadir la cita: $e");
    }
  }


  Future<void> deleteAppointment(Appointment appointment) async {
    try {
      await _appointmentService.deleteAppointment(appointment);
      
    } catch (e) {
      throw Exception('Error al eliminar la cita: $e');
    } finally{
      _appointments.removeWhere((item) => item.id == appointment.id);
    }
  }

 /* Future<void> updateAppointmentCompletion(Appointment appointment, bool isComplete) async {
    try {
      appointment.complete = isComplete;
      await _appointmentService.updateAppointment(appointment);
    } catch (e) {
      throw Exception('Error al completar la cita: $e');
    }
  }*/


}

