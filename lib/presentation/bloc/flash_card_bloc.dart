import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_flash_cards.dart';
import '../../domain/usecases/create_flash_card.dart';
import '../../domain/usecases/delete_flash_card.dart';
import 'flash_card_event.dart';
import 'flash_card_state.dart';

class FlashCardBloc extends Bloc<FlashCardEvent, FlashCardState> {
  final GetAllFlashCardsUsecase getAllFlashCards;
  final CreateFlashCardUsecase createFlashCard;
  final DeleteFlashCardUsecase deleteFlashCard;

  FlashCardBloc({
    required this.getAllFlashCards,
    required this.createFlashCard,
    required this.deleteFlashCard,
  }) : super(FlashCardInitial()) {
    on<LoadFlashCards>(_onLoadFlashCards);
    on<AddFlashCard>(_onAddFlashCard);
    on<DeleteFlashCard>(_onDeleteFlashCard);
  }

  Future<void> _onLoadFlashCards(
    LoadFlashCards event,
    Emitter<FlashCardState> emit,
  ) async {
    emit(FlashCardLoading());
    try {
      final flashCards = await getAllFlashCards();
      emit(FlashCardLoaded(flashCards));
    } catch (e) {
      emit(FlashCardError(e.toString()));
    }
  }

  Future<void> _onAddFlashCard(
    AddFlashCard event,
    Emitter<FlashCardState> emit,
  ) async {
    try {
      await createFlashCard(event.flashCard);
      // Reload danh sách ngay lập tức
      final flashCards = await getAllFlashCards();
      emit(FlashCardLoaded(flashCards));
    } catch (e) {
      emit(FlashCardError(e.toString()));
    }
  }

  Future<void> _onDeleteFlashCard(
    DeleteFlashCard event,
    Emitter<FlashCardState> emit,
  ) async {
    try {
      await deleteFlashCard(event.id);
      // Reload danh sách ngay lập tức
      final flashCards = await getAllFlashCards();
      emit(FlashCardLoaded(flashCards));
    } catch (e) {
      emit(FlashCardError(e.toString()));
    }
  }
}
