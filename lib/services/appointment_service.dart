import 'package:sqlite_flutter_crud/models/doctor.dart';
import '../models/appointment.dart';
import '../repositories/todo_repository.dart';

class AppointmentService {
  final TodoRepository _todoRepository;

  AppointmentService(this._todoRepository);

   Future<List<Appointment>> getAppointmentsAll(int id) async {
    return await _todoRepository.getAppointmentsForPlanAll(id);
  }

  Future<List<Appointment>> getAppointments(int id,String name) async {
    return await _todoRepository.getAppointmentsForPlan(id,name);
  }

  Future<int> addAppointment(Appointment appointment) async {
    return await _todoRepository.insertAppointment(appointment);
  }

  Future<void> deleteAppointment(Appointment appointment) async {
    await _todoRepository.deleteAppointment(appointment);
  }

}
