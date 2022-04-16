import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

class CustomChipView extends StatefulWidget {
  CustomChipView({Key key, this.title, this.isSelected, this.isSelectable})
      : super(key: key);
  final String title;
  bool isSelected;
  bool isSelectable;

  @override
  _CustomChipViewState createState() => new _CustomChipViewState();
}

class _CustomChipViewState extends State<CustomChipView>
    with AfterLayoutMixin<CustomChipView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    bool isSelectable = true;
    if (widget.isSelectable != null) {
      setState(() {
        isSelectable == widget.isSelectable;
      });
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: widget.isSelected ? Colors.pink : Color(0xFFF8BBD0),
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: Colors.white, width: 2)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              isSelectable
                  ? setState(() {
                      if (widget.isSelected) {
                        widget.isSelected = false;
                      } else {
                        widget.isSelected = true;
                      }
                    })
                  : onTapDoNothing();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: widget.isSelected ? Color(0xFFFFFFFF) : Colors.pink,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onTapDoNothing() {}
}
