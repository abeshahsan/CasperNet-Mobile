// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UsageData {
  String username;
  String fullName;
  String studentId;
  int totalUse;
  int estimatedBill;
  static const int freeLimit = 13200;
  int extraUse;

  UsageData({
    required this.username,
    required this.fullName,
    required this.studentId,
    required this.totalUse,
    required this.estimatedBill,
    required this.extraUse,
  });

  UsageData copyWith({
    String? username,
    String? fullName,
    String? studentId,
    int? totalUse,
    int? estimatedBill,
    int? extraUse,
  }) {
    return UsageData(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      totalUse: totalUse ?? this.totalUse,
      estimatedBill: estimatedBill ?? this.estimatedBill,
      extraUse: extraUse ?? this.extraUse,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'fullName': fullName,
      'studentId': studentId,
      'totalUse': totalUse,
      'estimatedBill': estimatedBill,
      'extraUse': extraUse,
    };
  }

  factory UsageData.fromMap(Map<String, dynamic> map) {
    return UsageData(
      username: map['username'] as String,
      fullName: map['fullName'] as String,
      studentId: map['studentId'] as String,
      totalUse: map['totalUse'] is int
          ? map['totalUse']
          : int.parse(map['totalUse'] as String),
      estimatedBill: map['estimatedBill'] is int
          ? map['estimatedBill']
          : int.parse(map['estimatedBill'] as String),
      extraUse: map['extraUse'] is int
          ? map['extraUse']
          : int.parse(map['extraUse'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory UsageData.fromJson(String source) {
    return UsageData.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  @override
  String toString() {
    return 'UsageData(username: $username, fullName: $fullName, studentId: $studentId, totalUse: $totalUse, estimatedBill: $estimatedBill, extraUse: $extraUse)';
  }

  @override
  bool operator ==(covariant UsageData other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.fullName == fullName &&
        other.studentId == studentId &&
        other.totalUse == totalUse &&
        other.estimatedBill == estimatedBill &&
        other.extraUse == extraUse;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        fullName.hashCode ^
        studentId.hashCode ^
        totalUse.hashCode ^
        estimatedBill.hashCode ^
        extraUse.hashCode;
  }
}
