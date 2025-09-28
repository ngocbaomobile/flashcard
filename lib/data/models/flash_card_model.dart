import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/flash_card.dart';

part 'flash_card_model.g.dart';

@JsonSerializable()
class FlashCardModel extends FlashCard {
  const FlashCardModel({
    required super.id,
    required super.frontImagePath,
    required super.backImagePath,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FlashCardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlashCardModelToJson(this);

  factory FlashCardModel.fromEntity(FlashCard flashCard) {
    return FlashCardModel(
      id: flashCard.id,
      frontImagePath: flashCard.frontImagePath,
      backImagePath: flashCard.backImagePath,
      createdAt: flashCard.createdAt,
      updatedAt: flashCard.updatedAt,
    );
  }

  FlashCard toEntity() {
    return FlashCard(
      id: id,
      frontImagePath: frontImagePath,
      backImagePath: backImagePath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
