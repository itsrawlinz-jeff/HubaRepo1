abstract class OnFetchEvent {
  const OnFetchEvent();
}

class OnFetchFinishedEvent extends OnFetchEvent {
  final bool fetchFinished;
  const OnFetchFinishedEvent(this.fetchFinished);
}


