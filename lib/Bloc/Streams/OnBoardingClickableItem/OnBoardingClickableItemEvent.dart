abstract class OnBoardingClickableItemEvent {
  const OnBoardingClickableItemEvent();
}

class OneItemClickedEvent extends OnBoardingClickableItemEvent {
  final int clickedId;
  const OneItemClickedEvent(this.clickedId);
}


