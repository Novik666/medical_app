import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_flutter_crud/models/user.dart';
import 'package:sqlite_flutter_crud/providers/appointmentAll_notifier.dart';
import '../models/appointment.dart';
import '../controllers/appointmentAll_controller.dart';
import '../repositories/todo_repository.dart';
import '../services/appointmentAll_service.dart';

class AppointmentScreenAll extends StatefulWidget {
  final User2 user2;

  const AppointmentScreenAll({super.key,required this.user2});
  @override
  State<AppointmentScreenAll> createState() => _AppointmentScreenAllState();
}

class _AppointmentScreenAllState extends State<AppointmentScreenAll> {
  final ScrollController _scrollController = ScrollController();
  late User2 user2;
  late AppointmentAllNotifier appointmentAllNotifier;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
 
    user2 = widget.user2;
   // user2 = widget.user2;
    appointmentAllNotifier = AppointmentAllNotifier(
      AppointmentAllController(
        user2,
        AppointmentAllService(
          Provider.of<TodoRepository>(context, listen: false),
        ),
      ),
    );
  if (user2.type=='Paciente'){
   _loadAppointmentss();
   }
   else{
    _loadAppointmentssM();
   }
  }

  Future<void> _loadAppointmentss() async {
    await appointmentAllNotifier.loadAppointmentAllsAll(widget.user2.id);
  }
    Future<void> _loadAppointmentssM() async {
    await appointmentAllNotifier.loadAppointmentAllsAllM(widget.user2.name);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppointmentAllNotifier>.value(
      value: appointmentAllNotifier,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
          'Nombre: ${user2.name}  Roll: ${user2.type}',
          style: const TextStyle(fontSize: 15.0),
        ),
        ),
        body: Consumer<AppointmentAllNotifier>(
          builder: (context, appointmentAllNotifier, child) {
            if (appointmentAllNotifier.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (appointmentAllNotifier.errorMessage != null) {
              return Center(
                child: Text(appointmentAllNotifier.errorMessage!),
              );
            } else {
              return _buildFilterWidget();
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilterWidget() {
  return Consumer<AppointmentAllNotifier>(
    builder: (context, appointmentAllNotifier, child) {
      if (appointmentAllNotifier.appointmentAlls.isEmpty) {
        return Center(
          child: Text('No hay citas'),
        );
      }
      return ListView.builder(
        itemCount: appointmentAllNotifier.appointmentAllCount,
        itemBuilder: (context, index) {
          final appointment = appointmentAllNotifier.appointmentAlls[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text('${appointment.nameDoctor} - ${appointment.speciality}'),
              subtitle: Text('${appointment.citeDate} - ${appointment.citeHour}'),
              onTap: () {
                appointmentAllNotifier.setCurrentAppointmentAll(appointment);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
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
                appointmentAllNotifier.deleteAppointmentAll(appointment);
                Navigator.of(context).pop();
                
              },
            ),
          ],
        );
      },
    );
  }

   /* void _showEditAppointmentDialog(BuildContext context, Appointment appointment) {
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
                appointmentAllNotifier.deleteAppointmentAll(appointment);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/
}