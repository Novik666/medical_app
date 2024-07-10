import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/models/doctor.dart';
import 'providers/doctor_notifier.dart';
import 'providers/appointment_notifier.dart';
import 'controllers/doctor_controller.dart';
import 'controllers/appointment_controller.dart';
import 'repositories/todo_repository.dart';
import 'services/doctor_service.dart';
import 'services/appointment_service.dart';
import 'Authtentication/admin_screen.dart';
import './Authtentication/login.dart';
import './views/appointment_screen.dart';

void main() => runApp(const PlanApp());

class PlanApp extends StatelessWidget {
  const PlanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TodoRepository>(
          create: (_) => TodoRepository(),
        ),
        ChangeNotifierProvider<DoctorNotifier>(
          create: (context) => DoctorNotifier(
            DoctorController(
              DoctorService(
                Provider.of<TodoRepository>(context, listen: false),
              ),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
        routes: {
          '/appointmentScreen': (context) => Consumer<DoctorNotifier>(
                builder: (context, doctorNotifier, _) {
                  final doctor = doctorNotifier.currentDoctor;
                  if (doctor != null) {
                    return ChangeNotifierProvider<AppointmentNotifier>(
                      create: (context) => AppointmentNotifier(
                        AppointmentController(
                          doctor,
                          AppointmentService(
                            Provider.of<TodoRepository>(context, listen: false),
                          ),
                        ),
                      ),
                      //child: AppointmentScreen(doctor2: doctor),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
        },
      ),
    );
  }
}
