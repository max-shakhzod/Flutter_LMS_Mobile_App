// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account()
  ..id = json['id'] as String?
  ..accountType = json['accountType'] as int?
  ..verified = json['verified'] as String?
  ..displayName = json['displayName'] as String?
  ..phoneNumber = json['phoneNumber'] as String?
  ..gender = json['gender'] as String?
  ..academicEnrolled = json['academicEnrolled'] as String?
  ..currentAcademicYear = json['currentAcademicYear'] as String?
  ..currentEnrolledCourseCode =
      (json['currentEnrolledCourseCode'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
  ..courseTaken =
      (json['courseTaken'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..courseAssigned = (json['courseAssigned'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'accountType': instance.accountType,
      'verified': instance.verified,
      'displayName': instance.displayName,
      'phoneNumber': instance.phoneNumber,
      'gender': instance.gender,
      'academicEnrolled': instance.academicEnrolled,
      'currentAcademicYear': instance.currentAcademicYear,
      'currentEnrolledCourseCode': instance.currentEnrolledCourseCode,
      'courseTaken': instance.courseTaken,
      'courseAssigned': instance.courseAssigned,
    };
