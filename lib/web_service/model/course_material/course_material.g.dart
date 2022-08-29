// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseMaterial _$CourseMaterialFromJson(Map<String, dynamic> json) =>
    CourseMaterial()
      ..id = json['id'] as String?
      ..materialName = json['materialName'] as String?
      ..materialPath = json['materialPath'] as String?
      ..materialType = json['materialType'] as String?
      ..createdDate = json['createdDate'] as String?
      ..fileSize = json['fileSize'] as String?
      ..courseBelonging = json['courseBelonging'] as String?
      ..submittedBy = json['submittedBy'] as String?;

Map<String, dynamic> _$CourseMaterialToJson(CourseMaterial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'materialName': instance.materialName,
      'materialPath': instance.materialPath,
      'materialType': instance.materialType,
      'createdDate': instance.createdDate,
      'fileSize': instance.fileSize,
      'courseBelonging': instance.courseBelonging,
      'submittedBy': instance.submittedBy,
    };
