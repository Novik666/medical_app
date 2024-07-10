import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../controllers/appointment_controller.dart';

class AppointmentNotifier extends ChangeNotifier {
  final AppointmentController _appointmentController;
  bool _isLoading = false;
  String? _errorMessage;
  Appointment? _currentAppointment;

  AppointmentNotifier(this._appointmentController) {
    loadAppointments(_appointmentController.doctor2.id,_appointmentController.doctor2.name);
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Appointment> get appointments => _appointmentController.appointments;
  int get appointmentCount => appointments.length;

  Future<void> loadAppointmentsAll(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      await _appointmentController.loadAppointmentAll(id);
    } catch (e) {
      _errorMessage = "No se pudo cargar las citas: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAppointments(int id, String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      await _appointmentController.loadAppointment(id, name);
    } catch (e) {
      _errorMessage = "No se pudo cargar las citas: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAppointment(Appointment newAppointment) async {
    try {
      _errorMessage = null;
      notifyListeners();
      await _appointmentController.addAppointment(newAppointment);
      loadAppointmentsAll(_appointmentController.doctor2.id); 
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error al añadir la cita: ${e.toString()}";
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteAppointment(Appointment appointment) async {
    try {
      _errorMessage = null;
      notifyListeners();
      await _appointmentController.deleteAppointment(appointment);
      loadAppointmentsAll(_appointmentController.doctor2.id); 
    } catch (e) {
      _errorMessage = "Error al eliminar la cita: $e";
    } finally {
      notifyListeners();
    }
  }

  
  void setCurrentAppointment(Appointment appointment) {
    _currentAppointment = appointment;
    notifyListeners();
  }

}
