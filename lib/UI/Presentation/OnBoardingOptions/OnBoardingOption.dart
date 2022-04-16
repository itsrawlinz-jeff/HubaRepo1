import 'package:dating_app/UI/Presentation/ExpandedBubbleChip/ExpandedBubbleChip.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

class OnBoardingOption extends StatefulWidget {
  OnBoardingOption({Key key, this.title, this.isSelected, this.isSelectable})
      : super(key: key);
  final String title;
  bool isSelected;
  bool isSelectable;

  @override
  _OnBoardingOptionState createState() => new _OnBoardingOptionState();
}

class _OnBoardingOptionState extends State<OnBoardingOption>
    with AfterLayoutMixin<OnBoardingOption> {
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
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: Row(
        children: <Widget>[
          //ExpandedBubbleChip

          Expanded(
            child: InkWell(
              splashColor: Colors.white24,
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              onTap: () {
                print('AM TAPPED');
                widget.isSelectable
                    ? setState(() {
                        if (widget.isSelected) {
                          print('isSelected');
                          widget.isSelected = false;
                        } else {
                          print('! isSelected');
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
                        color: widget.isSelected
                            ? Color(0xFFFFFFFF)
                            : Colors.black.withOpacity(.12))
                  ],
                  color: widget.isSelected ? Colors.pink : Color(0xFFF8BBD0),
                  borderRadius: radius,
                ),
                child: Row(
                  //crossAxisAlignment: align,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.27,
                        color:
                            widget.isSelected ? Color(0xFFFFFFFF) : Colors.pink,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  onTapDoNothing() {
    print('chip clicked');
  }
}
