import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';

class ExpandedBubbleChip extends StatefulWidget {
  ExpandedBubbleChip({this.title, this.isSelected, this.isSelectable});

  String title;
  bool isSelected;
  bool isSelectable;
  @override
  _ExpandedBubbleChipState createState() => new _ExpandedBubbleChipState();
}

class _ExpandedBubbleChipState extends State<ExpandedBubbleChip>
    with AfterLayoutMixin<ExpandedBubbleChip> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      topRight: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(10.0),
      topLeft: Radius.circular(10.0),
    );
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Expanded(
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              print('AM TAPPED');
              widget.isSelectable
                  ? setState(() {
                      if (widget.isSelected) {
                        widget.isSelected = false;
                      } else {
                        widget.isSelected = true;
                      }
                    })
                  : onTapDoNothing();
            },
            child: Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      /*color: widget.isSelected
                          ? Color(0xFFFFFFFF)
                          : Colors.black.withOpacity(.12))*/
                      color:  datingAppThemeChanger.selectedThemeData
                          .cl_cont_Sel_ClickableItem_Bshadow)
                ],
                //color: widget.isSelected ? Colors.pink : Color(0xFFF8BBD0),
                color:datingAppThemeChanger.selectedThemeData
                    .cl_cont_Sel_ClickableItem,
                borderRadius: radius,
              ),
              child: Row(
                //crossAxisAlignment: align,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: datingAppThemeChanger.selectedThemeData
                        .default_Sel_ClickableItem_TextStyle,/*TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0.27,
                      color:
                          widget.isSelected ? Color(0xFFFFFFFF) : Colors.pink,
                    ),*/
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  onTapDoNothing() {
    print('chip clicked');
  }
}
