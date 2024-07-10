import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../controllers/appointmentAll_controller.dart';

class AppointmentAllNotifier extends ChangeNotifier {
  final AppointmentAllController _appointmentAllController;
  bool _isLoading = false;
  String? _errorMessage;
  Appointment? _currentAppointmentAll;

  AppointmentAllNotifier(this._appointmentAllController) {
    loadAppointmentAllsAll(_appointmentAllController.user2.id);
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Appointment> get appointmentAlls => _appointmentAllController.appointmentAlls;
  int get appointmentAllCount => appointmentAlls.length;

  Future<void> loadAppointmentAllsAll(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      await _appointmentAllController.loadAppointmentAll(id);
    } catch (e) {
      _errorMessage = "No se pudo cargar las citas: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
    Future<void> loadAppointmentAllsAllM(String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      await _appointmentAllController.loadAppointmentAllM(name);
    } catch (e) {
      _errorMessage = "No se pudo cargar las citas: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> deleteAppointmentAll(Appointment appointment) async {
    try {
      _errorMessage = null;
      notifyListeners();
      await _appointmentAllController.deleteAppointmentAll(appointment);
      loadAppointmentAllsAll(_appointmentAllController.user2.id); 
    } catch (e) {
      _errorMessage = "Error al eliminar la cita: $e";
    } finally {
      notifyListeners();
    }
  }

  
  void setCurrentAppointmentAll(Appointment appointment) {
    _currentAppointmentAll = appointment;
    notifyListeners();
  }

}
