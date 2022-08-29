import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  String? id;

  /*  1 - student; 2 - lecturer  */
  int? accountType;

  /*  Account Verification  */
  String? verified;

  /*  Account Display Name  */
  String? displayName;

  /*  Account Phone Number  */
  String? phoneNumber;

  /*  Account Gender  */
  String? gender;

  /*  Academic Enrolled  */
  String? academicEnrolled;

  /*  Current Semester  */
  String? currentAcademicYear;

  /*  Current Semester Enrolled Course Code  */
  List<String>? currentEnrolledCourseCode;

  /*  Course Taken  */
  List<String>? courseTaken;

  /*  Course Assigned for Account Type 2  */
  List<String>? courseAssigned;

  Account();

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);

}