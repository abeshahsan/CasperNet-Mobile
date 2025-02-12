// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserData {
  final String username;
  final String password;

  UserData({
    required this.username,
    required this.password,
  });

  UserData copyWith({
    String? username,
    String? password,
  }) {
    return UserData(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserData(username: $username, password: $password)';

  @override
  bool operator ==(covariant UserData other) {
    if (identical(this, other)) return true;
  
    return 
      other.username == username &&
      other.password == password;
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode;
}
