import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/models/appointment.dart';

class AppointmentListItem extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onDelete;

  const AppointmentListItem({
    Key? key,
    required this.appointment,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black26,
            width: 1.0,
          ),
        ),
      ),
      child: ListTile(
        title: Text(
          appointment.description,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        onTap: () {
          // Implementar acción al tocar la cita si es necesario
        },
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete, color: Colors.redAccent),
        ),
      ),
    );
  }
}
