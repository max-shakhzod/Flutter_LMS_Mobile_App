// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course()
  ..id = json['id'] as String?
  ..courseCode = json['courseCode'] as String?
  ..courseName = json['courseName'] as String?
  ..courseOverview = json['courseOverview'] as String?
  ..courseHour =
      (json['courseHour'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..courseDescription = json['courseDescription'] as String?
  ..courseAnnouncement = json['courseAnnouncement'] as String?
  ..courseMidtermDate = json['courseMidtermDate'] as String?
  ..courseAssignmentDate = json['courseAssignmentDate'] as String?
  ..courseFinal = json['courseFinal'] as String?
  ..assignedTo = json['assignedTo'] as String?
  ..assignedToName = json['assignedToName'] as String?
  ..studentEnrolled = json['studentEnrolled'] as String?
  ..venue = json['venue'] as String?
  ..color = json['color'] as String?
  ..courseImage = json['courseImage'] as String?
  ..isHide = json['isHide'] as bool?
  ..createdAt = json['createdAt'] as String?;

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'id': instance.id,
      'courseCode': instance.courseCode,
      'courseName': instance.courseName,
      'courseOverview': instance.courseOverview,
      'courseHour': instance.courseHour,
      'courseDescription': instance.courseDescription,
      'courseAnnouncement': instance.courseAnnouncement,
      'courseMidtermDate': instance.courseMidtermDate,
      'courseAssignmentDate': instance.courseAssignmentDate,
      'courseFinal': instance.courseFinal,
      'assignedTo': instance.assignedTo,
      'assignedToName': instance.assignedToName,
      'studentEnrolled': instance.studentEnrolled,
      'venue': instance.venue,
      'color': instance.color,
      'courseImage': instance.courseImage,
      'isHide': instance.isHide,
      'createdAt': instance.createdAt,
    };
