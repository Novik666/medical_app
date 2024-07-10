class Person {
  final int? id;
  String name;
  String birthDate;


  
Person({
    this.id,
    this.name = '',
    this.birthDate = '',

  });

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
        id: map['id'],
        name: map['name'],
        birthDate: map['birthDate']);
  }

  Map<String, dynamic> toMap() {
    return {
      if(id != null) 
      'id': id,
      'name': name,
      'birthDate': birthDate
    };
  }
}