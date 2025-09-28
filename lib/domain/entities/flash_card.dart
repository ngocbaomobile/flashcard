import 'package:equatable/equatable.dart';

class FlashCard extends Equatable {
  final String id;
  final String frontImagePath;
  final String backImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FlashCard({
    required this.id,
    required this.frontImagePath,
    required this.backImagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        frontImagePath,
        backImagePath,
        createdAt,
        updatedAt,
      ];

  FlashCard copyWith({
    String? id,
    String? frontImagePath,
    String? backImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FlashCard(
      id: id ?? this.id,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
