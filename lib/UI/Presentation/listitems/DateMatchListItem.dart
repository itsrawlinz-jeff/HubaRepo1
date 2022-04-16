import 'package:dating_app/Models/JsonSerializable/Api/from/matches/DateMatchRespJModel.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/common_widgets.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateMatchListItem extends StatefulWidget {
  AnimationController animationController;
  Animation animation;
  IntindexCallback functionCallback;
  DateMatchRespJModel dateMatchRespJModel;

  DateMatchListItem({
    Key key,
    this.animationController,
    this.animation,
    this.functionCallback,
    this.dateMatchRespJModel,
  }) : super(key: key);

  @override
  _DateMatchListItemState createState() => _DateMatchListItemState();
}

class _DateMatchListItemState extends State<DateMatchListItem>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return Container(
          child: AnimatedBuilder(
            animation: widget.animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: widget.animation,
                child: new Transform(
                  transform: new Matrix4.translationValues(
                      0.0, 30 * (1.0 - widget.animation.value), 0.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 0, bottom: 0),
                        child: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 0),
                              child: InkWell(
                                onTap: () {
                                  widget.functionCallback(
                                      widget.dateMatchRespJModel);
                                },
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: DatingAppTheme.transparent,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0)),
                                  ),
                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 7),
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: datingAppThemeChanger
                                          .selectedThemeData
                                          .cl_dismissibleBackground_white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0)),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: 80,
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    width: 80,
                                                    height: 110,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                        ),
                                                        image: DecorationImage(
                                                            image: Image.asset(
                                                                    'assets/illustrations/back_pink_1.png')
                                                                .image,
                                                            fit: BoxFit.fill)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 115,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 0,
                                                      ),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.568,
                                                        child: Text(
                                                          widget
                                                                  .dateMatchRespJModel
                                                                  .matching_user
                                                                  .name +
                                                              ((widget.dateMatchRespJModel
                                                                              .match_to !=
                                                                          null &&
                                                                      isStringValid(widget
                                                                          .dateMatchRespJModel
                                                                          .match_to
                                                                          .name)
                                                                  ? ' and ' +
                                                                      widget
                                                                          .dateMatchRespJModel
                                                                          .match_to
                                                                          .name
                                                                  : '')),
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: datingAppThemeChanger
                                                              .selectedThemeData
                                                              .txt_stl_whitedarkerText_15_Med,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    ((widget.dateMatchRespJModel
                                                                    .decision !=
                                                                null &&
                                                            widget
                                                                    .dateMatchRespJModel
                                                                    .decision
                                                                    .name !=
                                                                null
                                                        ? Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 0,
                                                              ),
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1.568,
                                                                child: Text(
                                                                  'Decision: ${widget.dateMatchRespJModel.decision.name}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: datingAppThemeChanger
                                                                      .selectedThemeData
                                                                      .txt_stl_whitegrey_13_Book,
                                                                  /*overflow:
                                                                  TextOverflow
                                                                      .ellipsis,*/
                                                                  //maxLines: 2,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : invisibleWidget())),
                                                    ((widget.dateMatchRespJModel
                                                                .isuserrequested !=
                                                            null
                                                        ? Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 0,
                                                              ),
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1.568,
                                                                child: Text(
                                                                  'Is user request: ${((widget.dateMatchRespJModel.isuserrequested ? 'Yes' : 'No'))}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: datingAppThemeChanger
                                                                      .selectedThemeData
                                                                      .txt_stl_whitegrey_13_Book,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : invisibleWidget())),
                                                    ((widget.dateMatchRespJModel
                                                                .isuserrequested !=
                                                            null
                                                        ? Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 0,
                                                              ),
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1.568,
                                                                child: Text(
                                                                  'Approved: ${((widget.dateMatchRespJModel.approved != null && widget.dateMatchRespJModel.approved ? 'Yes' : 'No'))}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: datingAppThemeChanger
                                                                      .selectedThemeData
                                                                      .txt_stl_whitegrey_13_Book,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : invisibleWidget())),
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 0,
                                                        ),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.568,
                                                          child: Text(
                                                            'Active: ${((widget.dateMatchRespJModel.active != null && widget.dateMatchRespJModel.active ? 'Yes' : 'No'))}',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: datingAppThemeChanger
                                                                .selectedThemeData
                                                                .txt_stl_whitegrey_13_Book,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ((widget.dateMatchRespJModel
                                                                .createdate !=
                                                            null
                                                        ? Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.568,
                                                            child: Text(
                                                              'Date: ${getDateFormat_yyyymmmdd().format(widget.dateMatchRespJModel.createdate)}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: datingAppThemeChanger
                                                                  .selectedThemeData
                                                                  .txt_stl_whitegrey_13_Book,
                                                            ),
                                                          )
                                                        : invisibleWidget())),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

typedef IntindexCallback = void Function(
    DateMatchRespJModel dateMatchRespJModel);
