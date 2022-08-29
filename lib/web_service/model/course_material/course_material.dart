import 'package:json_annotation/json_annotation.dart';

part 'course_material.g.dart';

@JsonSerializable()
class CourseMaterial {
  String? id;

  /*  Material Name  */
  String? materialName;

  /*  Material Path  */
  String? materialPath;

  /*  Material Path  */
  String? materialType;

  /*  Date Created  */
  String? createdDate;

  /*  File Size  */
  String? fileSize;

  /*  Course Belonging  */
  String? courseBelonging;

  /*  Submitted By (Code)  */
  String? submittedBy;


  CourseMaterial();

  factory CourseMaterial.fromJson(Map<String, dynamic> json) => _$CourseMaterialFromJson(json);
  Map<String, dynamic> toJson() => _$CourseMaterialToJson(this);

}