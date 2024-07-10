import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_notifier.dart';
import './mixins/scroll_to_last_item_mixin.dart';
import './appointment_screen.dart';
import '../models/user.dart';
import '../Authtentication/login.dart';
import './appointmentAll_screen..dart';

class DoctorScreen extends StatefulWidget {
  final User2 user2;
  const DoctorScreen({super.key, required this.user2});
  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> with ScrollToLastItemMixin {
  final ScrollController _scrollController = ScrollController();
  late DoctorNotifier _doctorNotifier;
  late User2 user2;

  @override
  void initState() {
    super.initState();
    user2 = widget.user2;
    _doctorNotifier = Provider.of<DoctorNotifier>(context, listen: false);
  }

  @override
  ScrollController get scrollController => _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nombre: ${user2.name}  Roll: ${user2.type}',
          style: const TextStyle(fontSize: 15.0),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'historial':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentScreenAll(user2: user2),
                    ),
                  );
                  break;
                case 'cerrar':
                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
               const PopupMenuItem(
                  value: 'historial',
                  child: Text('Mostrar Historial de Citas Médicas'),
                ),
               const  PopupMenuItem(
                  value: 'cerrar',
                  child: Text('Cerrar Sesión'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildFilterWidget(),
            Expanded(
              child: _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterWidget() {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Filtrar por especialidad, nombre o ubicación',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: (filter) {
        _doctorNotifier.loadFilteredDoctors(filter);
      },
    );
  }

  Widget _buildList() {
    return Consumer<DoctorNotifier>(
      builder: (context, doctorNotifier, child) {
        if (doctorNotifier.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (doctorNotifier.doctors.isEmpty) {
          return const Center(
            child: Text('No hay médicos'),
          );
        }
        return ListView.builder(
          itemCount: doctorNotifier.doctorsCount,
          itemBuilder: (context, index) {
            final doctor = doctorNotifier.doctors[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text('${doctor.name} - ${doctor.speciality}'),
                subtitle: Text('${doctor.location} - ${doctor.birthDate}'),
                onTap: () {
                  // Establecer el doctor actual y navegar a la pantalla de citas
                  _doctorNotifier.setCurrentDoctor(doctor);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentScreen(doctor2: doctor, user2: user2),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
