import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

class BubbleChip extends StatefulWidget {
  BubbleChip(
      {this.message,
      this.isSelected,
      this.isSelectable});

  final String message;

  bool isSelected;
  bool isSelectable;
  @override
  _BubbleChipState createState() => new _BubbleChipState();
}

class _BubbleChipState extends State<BubbleChip>
    with AfterLayoutMixin<BubbleChip> {
  /*String message, time;
  var delivered, isMe;
  bool isSelected;
  bool isSelectable;*/

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    //final bg = isSelected ? Colors.pink : Color(0xFFF8BBD0);
    //final bg = isMe ? Colors.white : Colors.greenAccent.shade100;
    //final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    //final icon = delivered ? Icons.done_all : Icons.done;
    final radius = BorderRadius.only(
      topRight: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(10.0),
      topLeft: Radius.circular(10.0),
    );
    /*final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );*/
    return InkWell(
      splashColor: Colors.white24,
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
      child: Column(
        //crossAxisAlignment: align,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
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
            child: Stack(
              children: <Widget>[
                Text(
                  widget.message,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: widget.isSelected ? Color(0xFFFFFFFF) : Colors.pink,
                  ),
                ),

                /*Padding(
                padding: EdgeInsets.only(right: 48.0),
                child: Text(message),
              ),*/
                /*Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )*/
              ],
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
