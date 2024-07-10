import 'package:sqlite_flutter_crud/models/doctor.dart';
import '../models/appointment.dart';
import '../repositories/todo_repository.dart';

class AppointmentAllService {
  final TodoRepository _todoRepository;

  AppointmentAllService(this._todoRepository);

   Future<List<Appointment>> getAppointmentAllsAll(int id) async {
    return await _todoRepository.getAppointmentsForPlanAll(id);
  }

  
   Future<List<Appointment>> getAppointmentAllsAllM(String name) async {
    return await _todoRepository.getAppointmentsForPlanAllM(name);
  }


  Future<void> deleteAppointmentAll(Appointment appointment) async {
    await _todoRepository.deleteAppointment(appointment);
  }

}
