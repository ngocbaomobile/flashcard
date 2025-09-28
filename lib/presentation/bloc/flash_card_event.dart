import 'package:equatable/equatable.dart';
import '../../domain/entities/flash_card.dart';

abstract class FlashCardEvent extends Equatable {
  const FlashCardEvent();

  @override
  List<Object?> get props => [];
}

class LoadFlashCards extends FlashCardEvent {}

class AddFlashCard extends FlashCardEvent {
  final FlashCard flashCard;

  const AddFlashCard(this.flashCard);

  @override
  List<Object?> get props => [flashCard];
}

class DeleteFlashCard extends FlashCardEvent {
  final String id;

  const DeleteFlashCard(this.id);

  @override
  List<Object?> get props => [id];
}
