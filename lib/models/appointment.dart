

class Appointment {
  final int? id;
  String nameDoctor;
  String speciality;
  String citeDate;
  String citeHour;
  String description;
  final int userId;

  Appointment({
    this.id,
    this.nameDoctor = '',
    this.speciality = '',
    this.citeDate = '',
    this.citeHour = '',
    this.description = '',
    required this.userId,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
        id: map['id'],
        nameDoctor: map['nameDoctor'],
        speciality: map['speciality'],
        citeDate: map['citeDate'],
        citeHour: map['citeHour'],
        description: map['description'],
        userId: map['userId']);
  }

  Map<String, dynamic> toMap() {
    return {
      if(id != null) 'id': id,
      'nameDoctor': nameDoctor,
      'speciality': speciality,
      'citeDate': citeDate,
      'citeHour': citeHour,
      'description': description,
      'userId': userId
    };
  }
}
