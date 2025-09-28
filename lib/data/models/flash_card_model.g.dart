// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlashCardModel _$FlashCardModelFromJson(Map<String, dynamic> json) =>
    FlashCardModel(
      id: json['id'] as String,
      frontImagePath: json['front_image_path'] as String,
      backImagePath: json['back_image_path'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at'] as int),
    );

Map<String, dynamic> _$FlashCardModelToJson(FlashCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'front_image_path': instance.frontImagePath,
      'back_image_path': instance.backImagePath,
      'created_at': instance.createdAt.millisecondsSinceEpoch,
      'updated_at': instance.updatedAt.millisecondsSinceEpoch,
    };
