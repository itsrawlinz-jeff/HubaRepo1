abstract class PageDraggerEvent {
  const PageDraggerEvent();
}

class IfDragPageEvent extends PageDraggerEvent {
  final bool isEnableDragWidgetVal;
  const IfDragPageEvent(this.isEnableDragWidgetVal);
}
