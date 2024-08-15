import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final DateTime dateOfBirth;
  final String password;
  final String phone;
  final String district;
  final String project;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.password,
    required this.phone,
    required this.district,
    required this.project,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? dateOfBirth,
    String? password,
    String? phone,
    String? district,
    String? project,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      district: district ?? this.district,
      project: project ?? this.project,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'password': password,
      'phone': phone,
      'district': district,
      'project': project,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      dateOfBirth: DateTime.parse(map['date_of_birth'] as String),
      password: map['password'] as String,
      phone: map['phone'] as String,
      district: map['district'] as String,
      project: map['project'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, dateOfBirth: $dateOfBirth, password: $password, phone: $phone, district: $district, project: $project)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.dateOfBirth == dateOfBirth &&
        other.password == password &&
        other.phone == phone &&
        other.district == district &&
        other.project == project;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        dateOfBirth.hashCode ^
        password.hashCode ^
        phone.hashCode ^
        district.hashCode ^
        project.hashCode;
  }
}
