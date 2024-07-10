class Doctor {
  final int? id;
  String speciality;
  String location;
  String hireDate;
  final int personId;

  Doctor({
    this.id,
    this.speciality = '',
    this.location = '',
    this.hireDate = '',
    required this.personId,
  });

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
        id: map['id'],
        speciality: map['speciality'],
        location: map['location'],
        hireDate: map['hireDate'],
        personId: map['personId']);
  }

  Map<String, dynamic> toMap() {
    return {
      if(id != null) 
      'id': id,
      'speciality': speciality,
      'location': location,
      'hireDate': hireDate,
      'personId': personId
    };
  }
}


class Doctor2 {
  int id;
  String name;
  String speciality;
  String location;
  String birthDate;
  String hireDate;

  Doctor2({
    this.id=0,
    this.name='',
    this.speciality='',
    this.location='',
    this.birthDate='',
    this.hireDate='',
  });

  factory Doctor2.fromMap(Map<String, dynamic> map) {
    return Doctor2(
      id: map['id'],
      name: map['name'],
      birthDate: map['birthDate'],
      speciality: map['speciality'],
      location: map['location'],
      hireDate: map['hireDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate,
      'speciality': speciality,
      'location': location,
      'hireDate': hireDate,
    };
  }
}