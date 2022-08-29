import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  String? id;

  /*  Course Code  */
  String? courseCode;

  /*  Course Name  */
  String? courseName;

  /*  Course Overview  */
  String? courseOverview;

  /*  Course Duration  */
  List<String>? courseHour;

  /*  Course Description  */
  String? courseDescription;

  /*  Course Announcement  */
  String? courseAnnouncement;

  /*  Course Midterm  */
  String? courseMidtermDate;

  /*  Course Midterm  */
  String? courseAssignmentDate;

  /*  Course Final  */
  String? courseFinal;

  /*  Assigned To (Lecture Code)  */
  String? assignedTo;

  /*  Assigned To (Lecture Name)  */
  String? assignedToName;

  /*  Number of Student Enrolled  */
  String? studentEnrolled;

  /*  Course Venue  */
  String? venue;

  /*  Course Color  */
  String? color;

  /*  Course Image  */
  String? courseImage;

  /*  HIDE COURSE  */
  bool? isHide;

  /*  COURSE CREATED TIME*/
  String? createdAt;



  Course();

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);

}