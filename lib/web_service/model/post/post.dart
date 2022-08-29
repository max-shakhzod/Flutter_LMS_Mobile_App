import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  /*  Post Id  */
  String? id;

  /*  Post Title */
  String? title;

  /*  Post Type */
  String? type;

  /*  Post Color */
  String? typeColor;

  /*  Post Created Date*/
  String? createdDate;

  /*  Post Last Update  */
  String? lastUpdate;

  /*  Post Creator ID*/
  String? createdBy;

  /*  Post Creator Name*/
  String? createdByName;

  /*  Course Belonging */
  String? courseBelonging;

  /*  Post Color */
  String? color;

  /*  Post Notes*/
  String? notes;

  /*  Post Attachments */
  List<String>? attachments;

  /*  Post Likes */
  int? likes;

  /*  Post Comment Count */
  int? commentsCount;

  Post();

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

}