import '../../domain/entities/random_text_entity.dart';

abstract class RandomTextState {}

class RandomTextInitial extends RandomTextState {
  final RandomTextEntity entity;

  RandomTextInitial(this.entity);
}

class RandomTextLoading extends RandomTextState {
  final RandomTextEntity entity;

  RandomTextLoading(this.entity);
}

class RandomTextShuffling extends RandomTextState {
  final RandomTextEntity entity;

  RandomTextShuffling(this.entity);
}

class RandomTextResult extends RandomTextState {
  final RandomTextEntity entity;

  RandomTextResult(this.entity);
}

class RandomTextError extends RandomTextState {
  final String message;
  final RandomTextEntity entity;

  RandomTextError(this.message, this.entity);
}
