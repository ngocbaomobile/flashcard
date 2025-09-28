import 'package:equatable/equatable.dart';
import '../../domain/entities/flash_card.dart';

abstract class FlashCardState extends Equatable {
  const FlashCardState();

  @override
  List<Object?> get props => [];
}

class FlashCardInitial extends FlashCardState {}

class FlashCardLoading extends FlashCardState {}

class FlashCardLoaded extends FlashCardState {
  final List<FlashCard> flashCards;

  const FlashCardLoaded(this.flashCards);

  @override
  List<Object?> get props => [flashCards];
}

class FlashCardError extends FlashCardState {
  final String message;

  const FlashCardError(this.message);

  @override
  List<Object?> get props => [message];
}
