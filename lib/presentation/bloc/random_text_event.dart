abstract class RandomTextEvent {}

class ParseTextEvent extends RandomTextEvent {
  final String inputText;

  ParseTextEvent(this.inputText);
}

class StartShuffleEvent extends RandomTextEvent {
  final List<String> items;

  StartShuffleEvent(this.items);
}

class StopShuffleEvent extends RandomTextEvent {}

class UpdateResultEvent extends RandomTextEvent {
  final String result;

  UpdateResultEvent(this.result);
}
