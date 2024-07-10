import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/controllers/doctor_controller.dart';
import '../models/doctor.dart';
import '../repositories/todo_repository.dart';

class DoctorNotifier extends ChangeNotifier {
  final DoctorController _doctorController;
  bool _isLoading = false;
  String? _errorMessage;
  Doctor2? _currentDoctor;

  DoctorNotifier(this._doctorController) {
    _loadDoctors(); // Carga inicial de todos los doctores
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Doctor2> get doctors => _doctorController.doctors;
  int get doctorsCount => doctors.length;
  Doctor2? get currentDoctor => _currentDoctor;

  Future<void> _loadDoctors() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _doctorController.loadDoctors();
    } catch (e) {
      _errorMessage = "No se pudieron cargar los doctores: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFilteredDoctors(String filter) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _doctorController.loadFilter(filter); 
    } catch (e) {
      _errorMessage = "No se pudieron cargar los doctores filtrados: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCurrentDoctor(Doctor2 doctor) {
    _currentDoctor = doctor;
    notifyListeners();
  }
}




/*
  Future<void> addPlan(String name) async {
    try {
      _errorMessage = null;
      notifyListeners();
      await _doctorController.doctorPlan(name);
    } catch (e) {
      _errorMessage = "Error al añadir el plan";
    }
    notifyListeners();
  }

  Future<void> deletePlan(Plan plan) async {
    try {
      _errorMessage = null;
      notifyListeners();
      await _planController.deletePlan(plan);
    } catch (e) {
      _errorMessage = "Error al eliminar el plan $e";
    }
    notifyListeners();
  }*/

