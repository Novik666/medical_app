import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/models/user.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';
import '../controllers/appointment_controller.dart';
import '../providers/appointment_notifier.dart';
import '../repositories/todo_repository.dart';
import '../services/appointment_service.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  final Doctor2 doctor2;
  final User2 user2;

  const AppointmentScreen({super.key, required this.doctor2, required this.user2});
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final ScrollController _scrollController = ScrollController();
  late Doctor2 doctor2;
  late User2 user2;
  late AppointmentNotifier appointmentNotifier;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    doctor2 = widget.doctor2;
    user2 = widget.user2;
    appointmentNotifier = AppointmentNotifier(
      AppointmentController(
        doctor2,
        AppointmentService(
          Provider.of<TodoRepository>(context, listen: false),
        ),
      ),
    );
   _loadAppointments();
    
  }

  Future<void> _loadAppointments() async {
    await appointmentNotifier.loadAppointments(widget.user2.id, doctor2.name);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppointmentNotifier>.value(
      value: appointmentNotifier,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Médico: ${doctor2.name}'),
        ),
        body: Consumer<AppointmentNotifier>(
          builder: (context, appointmentNotifier, child) {
            if (appointmentNotifier.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (appointmentNotifier.errorMessage != null) {
              return Center(
                child: Text(appointmentNotifier.errorMessage!),
              );
            } else {
              return _buildFilterWidget();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddAppointmentDialog(appointmentNotifier),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

Widget _buildFilterWidget() {
  return Consumer<AppointmentNotifier>(
    builder: (context, appointmentNotifier, child) {
      if (appointmentNotifier.appointments.isEmpty) {
        return Center(
          child: Text('No hay citas'),
        );
      }
      return ListView.builder(
        itemCount: appointmentNotifier.appointmentCount,
        itemBuilder: (context, index) {
          final appointment = appointmentNotifier.appointments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text('${appointment.nameDoctor} - ${appointment.speciality}'),
              subtitle: Text('${appointment.citeDate} - ${appointment.citeHour}'),
              onTap: () {
                appointmentNotifier.setCurrentAppointment(appointment);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showEditAppointmentDialog(context, appointment),
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  ),
                  IconButton(
                    onPressed: () => _showDeleteAppointmentDialog(context, appointment),
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


  

void _showAddAppointmentDialog(AppointmentNotifier appointmentNotifier) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final TextEditingController doctorController = TextEditingController();
      final TextEditingController specialityController = TextEditingController();
      final TextEditingController citeDateController = TextEditingController();
      final TextEditingController citeHourController = TextEditingController();
      final TextEditingController descriptionController = TextEditingController();

      return AlertDialog(
        title: const Text("Añadir nueva Cita"),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple.withOpacity(.2),
                  ),
                  child: TextField(
                    controller: doctorController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.person),
                      border: InputBorder.none,
                      hintText: widget.doctor2.name,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple.withOpacity(.2),
                  ),
                  child: TextField(
                    controller: specialityController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.medical_services),
                      border: InputBorder.none,
                      hintText: widget.doctor2.speciality,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple.withOpacity(.2),
                  ),
                  child: TextField(
                    controller: citeDateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          citeDateController.text = formattedDate;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      border: InputBorder.none,
                      hintText: "Fecha de la Cita",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple.withOpacity(.2),
                  ),
                  child: TextField(
                    controller: citeHourController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.access_time),
                      border: InputBorder.none,
                      hintText: "Hora de la Cita",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple.withOpacity(.2),
                  ),
                  child: TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.description),
                      border: InputBorder.none,
                      hintText: "Descripción",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Añadir"),
            onPressed: () async {
              final newAppointment = Appointment(
              nameDoctor: doctor2.name,
              speciality: doctor2.speciality,
              citeDate: citeDateController.text,
              citeHour: citeHourController.text,
              description: descriptionController.text,
              userId: user2.id,
            );

            await appointmentNotifier.addAppointment(newAppointment);
            Navigator.of(context).pop();
            _loadAppointments();
            if (appointmentNotifier.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(appointmentNotifier.errorMessage!)),
                
              );
            } else {
              
            }
          },
          ),
        ],
      );
    },
  );
}



  void _showDeleteAppointmentDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar cita'),
          content: const Text('¿Está seguro de eliminar la cita?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                appointmentNotifier.deleteAppointment(appointment);
                _loadAppointments();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  
  void _showEditAppointmentDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar cita'),
          content: const Text('¿Está seguro de eliminar la cita?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                appointmentNotifier.deleteAppointment(appointment);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
