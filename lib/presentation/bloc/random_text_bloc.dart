import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/random_text_entity.dart';
import '../../domain/usecases/parse_text_to_items.dart';
import '../../domain/usecases/select_random_item.dart';
import 'random_text_event.dart';
import 'random_text_state.dart';

class RandomTextBloc extends Bloc<RandomTextEvent, RandomTextState> {
  final ParseTextToItemsUsecase parseTextToItemsUsecase;
  final SelectRandomItemUsecase selectRandomItemUsecase;

  Timer? _shuffleTimer;
  final Random _random = Random();

  RandomTextBloc({
    required this.parseTextToItemsUsecase,
    required this.selectRandomItemUsecase,
  }) : super(RandomTextInitial(const RandomTextEntity(
          items: [],
          selectedItem: '...',
          isShuffling: false,
        ))) {
    on<ParseTextEvent>(_onParseText);
    on<StartShuffleEvent>(_onStartShuffle);
    on<StopShuffleEvent>(_onStopShuffle);
    on<UpdateResultEvent>(_onUpdateResult);
  }

  Future<void> _onParseText(
      ParseTextEvent event, Emitter<RandomTextState> emit) async {
    try {
      final currentEntity = _getCurrentEntity();
      emit(RandomTextLoading(currentEntity));

      final items = await parseTextToItemsUsecase(event.inputText);

      if (items.isEmpty) {
        emit(RandomTextError(
          'Vui lòng nhập các giá trị ngăn cách bởi dấu phẩy.',
          currentEntity.copyWith(items: items),
        ));
        return;
      }

      final updatedEntity = currentEntity.copyWith(
        items: items,
        selectedItem: '...',
        isShuffling: false,
      );

      emit(RandomTextInitial(updatedEntity));
    } catch (e) {
      final currentEntity = _getCurrentEntity();
      emit(RandomTextError('Lỗi khi phân tích văn bản: $e', currentEntity));
    }
  }

  void _onStartShuffle(StartShuffleEvent event, Emitter<RandomTextState> emit) {
    if (event.items.isEmpty) {
      final currentEntity = _getCurrentEntity();
      emit(RandomTextError('Danh sách trống', currentEntity));
      return;
    }

    final currentEntity = _getCurrentEntity();
    final updatedEntity = currentEntity.copyWith(
      items: event.items,
      selectedItem: '...',
      isShuffling: true,
    );

    emit(RandomTextShuffling(updatedEntity));

    _startShuffleAnimation(event.items, emit);

    // Dừng hiệu ứng sau 2 giây và chọn kết quả cuối cùng
    Timer(const Duration(seconds: 2), () {
      add(StopShuffleEvent());
    });
  }

  void _onStopShuffle(StopShuffleEvent event, Emitter<RandomTextState> emit) {
    _shuffleTimer?.cancel();

    final currentEntity = _getCurrentEntity();
    final selectedItem = selectRandomItemUsecase(currentEntity.items);
    final updatedEntity = currentEntity.copyWith(
      selectedItem: selectedItem,
      isShuffling: false,
    );

    emit(RandomTextResult(updatedEntity));
  }

  void _onUpdateResult(UpdateResultEvent event, Emitter<RandomTextState> emit) {
    final currentEntity = _getCurrentEntity();
    final updatedEntity = currentEntity.copyWith(selectedItem: event.result);
    emit(RandomTextShuffling(updatedEntity));
  }

  void _startShuffleAnimation(
      List<String> items, Emitter<RandomTextState> emit) {
    _shuffleTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final currentEntity = _getCurrentEntity();
      if (!currentEntity.isShuffling) {
        timer.cancel();
        return;
      }

      final randomIndex = _random.nextInt(items.length);
      final tempItem = items[randomIndex];
      add(UpdateResultEvent(tempItem));
    });
  }

  RandomTextEntity _getCurrentEntity() {
    if (state is RandomTextInitial) {
      return (state as RandomTextInitial).entity;
    } else if (state is RandomTextLoading) {
      return (state as RandomTextLoading).entity;
    } else if (state is RandomTextShuffling) {
      return (state as RandomTextShuffling).entity;
    } else if (state is RandomTextResult) {
      return (state as RandomTextResult).entity;
    } else if (state is RandomTextError) {
      return (state as RandomTextError).entity;
    }
    return const RandomTextEntity(
      items: [],
      selectedItem: '...',
      isShuffling: false,
    );
  }

  @override
  Future<void> close() {
    _shuffleTimer?.cancel();
    return super.close();
  }
}
