abstract class OnBoardingPageEvent {
  const OnBoardingPageEvent();
}

class OnBoardingPageChangedEvent extends OnBoardingPageEvent {
  final int pageIndex;
  const OnBoardingPageChangedEvent(this.pageIndex);
}


