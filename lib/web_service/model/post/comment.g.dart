// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment()
  ..id = json['id'] as String?
  ..commentCreated = json['commentCreated'] as String?
  ..createdDate = json['createdDate'] as String?
  ..createdBy = json['createdBy'] as String?
  ..createdByName = json['createdByName'] as String?
  ..lastUpdate = json['lastUpdate'] as String?
  ..notes = json['notes'] as String?
  ..postId = json['postId'] as String?
  ..courseBelonging = json['courseBelonging'] as String?
  ..attachments =
      (json['attachments'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'commentCreated': instance.commentCreated,
      'createdDate': instance.createdDate,
      'createdBy': instance.createdBy,
      'createdByName': instance.createdByName,
      'lastUpdate': instance.lastUpdate,
      'notes': instance.notes,
      'postId': instance.postId,
      'courseBelonging': instance.courseBelonging,
      'attachments': instance.attachments,
    };
