abstract class KeyBoardVisibleEvent {
  const KeyBoardVisibleEvent();
}

class ToggleKeyBoardVisEvent extends KeyBoardVisibleEvent {
  final bool keyboardShownVal;
  const ToggleKeyBoardVisEvent(this.keyboardShownVal);
}


