class User {
  final int? id;
  String user;
  String password;
  String type;
  final int personId;

  User({
    this.id,
    this.user = '',
    this.password = '',
    this.type = '',
    this.personId=0,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        user: map['user'],
        password: map['password'],
        type: map['type'],
        personId: map['personId']);
  }

  Map<String, dynamic> toMap() {
    return {
      if(id != null) 
      'id': id,
      'user': user,
      'password': password,
      'type': type,
      'personId': personId
    };
  }
}

class User2 {
  int id;
  String name;
  String type;

  User2({
    this.id=0,
    this.name = '',
    this.type = '',
  });

  factory User2.fromMap(Map<String, dynamic> map) {
    return User2(
        id: map['id'],
        name: map['name'],
        type: map['type'],
        );
  }

  Map<String, dynamic> toMap() {
    return {
      if(id != null) 
      'id': id,
      'name': name,
      'type': type,
    };
  }
}