import 'dart:async';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/matches/MatchDecisionRespJModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';

class MatchDecisionPickerOnline extends StatefulWidget {
  MatchDecisionPickerOnline({
    Key key,
    this.selectedMatchDecisionRespJModel,
    @required this.onChanged,
    this.dense = false,
    this.showFlag = true,
    this.showDialingCode = false,
    this.showName = true,
    this.showCurrency = false,
    this.showCurrencyISO = false,
    this.nameTextStyle,
    this.dialingCodeTextStyle,
    this.currencyTextStyle,
    this.currencyISOTextStyle,
    this.matchDecisionRespJModelList,
    this.selectedMatchDecisionRespJModelChanged_NavigationDataBLoC,
    this.functValidateTicket,
    this.isDisabled,
    this.hintText,
    this.onSelectedOnlineUserChanged,
    this.dropdownPadding,
    this.onClickedCallback,
    this.validateagainst,
    this.validateagainstChanged,
    this.suggestions_changed_NavigationDataBLoC,
  }) : super(key: key);

  MatchDecisionRespJModel selectedMatchDecisionRespJModel;
  ValueChanged<MatchDecisionRespJModel> onChanged;
  bool dense;
  bool showFlag;
  bool showDialingCode;
  bool showName;
  bool showCurrency;
  bool showCurrencyISO;
  TextStyle nameTextStyle;
  TextStyle dialingCodeTextStyle;
  TextStyle currencyTextStyle;
  TextStyle currencyISOTextStyle;
  List<MatchDecisionRespJModel> matchDecisionRespJModelList;
  NavigationDataBLoC selectedMatchDecisionRespJModelChanged_NavigationDataBLoC;
  NavigationDataBLoC validateagainstChanged;
  bool isDisabled;
  String hintText;
  OnSelectedItemchangedCallback onSelectedOnlineUserChanged;
  EdgeInsetsGeometry dropdownPadding;
  ValidatorCallback functValidateTicket;
  OnClickedCallback onClickedCallback;
  List<int> validateagainst;
  NavigationDataBLoC suggestions_changed_NavigationDataBLoC;

  @override
  State<StatefulWidget> createState() => _MatchDecisionPickerOnlineState();
}

class _MatchDecisionPickerOnlineState extends State<MatchDecisionPickerOnline>
    with AfterLayoutMixin<MatchDecisionPickerOnline> {
  MatchDecisionRespJModel selectedMatchDecisionRespJModelStless = null;
  TextEditingController assignedTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setUpData();
    setUpListeners();
    addListeners();
  }

  addListeners() {
    if (widget.validateagainstChanged != null) {
      widget.validateagainstChanged.stream_counter.listen((value) {
        NavigationData navigationData = value;
        if (navigationData != null && navigationData.intList != null) {
          print('ADDED TO validateagainst ');
          widget.validateagainst = navigationData.intList;
        }
      });
    }
  }

  setUpData() {
    assignedTextEditingController.text =
        ((widget.selectedMatchDecisionRespJModel != null
            ? '${widget.selectedMatchDecisionRespJModel.name}'
            : ''));
    if (widget.selectedMatchDecisionRespJModel != null) {
      selectedMatchDecisionRespJModelStless =
          widget.selectedMatchDecisionRespJModel;
    } else {
      selectedMatchDecisionRespJModelStless = null;
    }
  }

  setUpListeners() {
    widget.selectedMatchDecisionRespJModelChanged_NavigationDataBLoC
        .stream_counter
        .listen((value) {
      NavigationData navigationData = value;
      if (navigationData != null) {
        widget.selectedMatchDecisionRespJModel =
            navigationData.matchDecisionRespJModel;
        setUpData();
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return _renderDenseDisplay(context, selectedMatchDecisionRespJModelStless);
  }

  _renderDenseDisplay(
      BuildContext context, MatchDecisionRespJModel displayOnlineuser) {
    return Consumer<DatingAppThemeChanger>(
      builder: (context, datingAppThemeChanger, child) {
        return InkWell(
          child: Container(
            height: 48,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 48,
                    width: 23,
                    child: TextFormField(
                      onChanged: (String txt) {},
                      style: datingAppThemeChanger
                          .selectedThemeData.txt_stl_f14w500_Med,
                      cursorColor:
                          datingAppThemeChanger.selectedThemeData.cl_grey,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.check,
                          color: DatingAppTheme.pltf_grey,
                          //datingAppThemeChanger.selectedThemeData.cl_grey,
                        ),
                        hintText:
                            ((widget.hintText != null ? widget.hintText : '')),
                        hintStyle: datingAppThemeChanger.selectedThemeData
                            .txt_stl_hint_f14w500_Med_pltf_grey,
                        enabled: false,
                      ),
                      autofocus: false,
                      enabled: false,
                      controller: assignedTextEditingController,
                      validator: ((widget.functValidateTicket != null
                          ? widget.functValidateTicket
                          : validateTicket)),
                    ),
                  ),
                ),
                dropDownIconWithColor(datingAppThemeChanger),
              ],
            ),
          ),
          onTap: () {
            if (widget.onClickedCallback != null) {
              widget.onClickedCallback();
            }
            _onselectOnlineuser(context, selectedMatchDecisionRespJModelStless,
                    widget.matchDecisionRespJModelList)
                .then((onValue) {
              if (onValue != null) {
                if (widget.validateagainst != null) {
                  print('matchagainst==');
                  print(onValue.id.toString());
                  for (int c in widget.validateagainst) {
                    print(c.toString());
                  }
                  int foundInList = widget.validateagainst.firstWhere((obj) {
                    return obj != null && obj == onValue.id;
                  }, orElse: () => null);

                  if (foundInList != null) {
                    return;
                  }
                }
                setState(() {
                  selectedMatchDecisionRespJModelStless = onValue;
                  widget.selectedMatchDecisionRespJModel =
                      selectedMatchDecisionRespJModelStless;
                  assignedTextEditingController.text =
                      ((selectedMatchDecisionRespJModelStless != null
                          ? '${selectedMatchDecisionRespJModelStless.name}'
                          : ''));
                });
              }
            }, onError: (error) {});
          },
        );
      },
    );
  }

  Widget dropDownIconWithColor(DatingAppThemeChanger datingAppThemeChanger) {
    if (widget.isDisabled != null) {
      if (widget.isDisabled) {
        return ((widget.dropdownPadding != null
            ? Padding(
                padding: widget.dropdownPadding,
                child: Icon(Icons.arrow_drop_down,
                    color: datingAppThemeChanger
                        .selectedThemeData.cl_real_grey_grey),
              )
            : Icon(Icons.arrow_drop_down,
                color: datingAppThemeChanger
                    .selectedThemeData.cl_real_grey_grey)));
      } else {
        return ((widget.dropdownPadding != null
            ? Padding(
                padding: widget.dropdownPadding,
                child: Icon(Icons.arrow_drop_down,
                    color: datingAppThemeChanger.selectedThemeData.cl_grey),
              )
            : Icon(Icons.arrow_drop_down,
                color: datingAppThemeChanger.selectedThemeData.cl_grey)));
      }
    } else {
      return ((widget.dropdownPadding != null
          ? Padding(
              padding: widget.dropdownPadding,
              child: Icon(Icons.arrow_drop_down,
                  color: datingAppThemeChanger.selectedThemeData.cl_grey),
            )
          : Icon(Icons.arrow_drop_down,
              color: datingAppThemeChanger.selectedThemeData.cl_grey)));
    }
  }

  String validateTicket(String value) {
    return null;
  }

  String validateInput(String value) {
    if (value.isEmpty || !(value.trim().length > 0)) {
      return 'Filled required';
    }
    return null;
  }

  Future<MatchDecisionRespJModel> _onselectOnlineuser(
    BuildContext context,
    MatchDecisionRespJModel defaultOnlineuser,
    List<MatchDecisionRespJModel> matchDecisionRespJModelList,
  ) async {
    MatchDecisionRespJModel picked_Onlineuser = null;
    final MatchDecisionRespJModel picked = await showMatchDecisionPickerOnline(
      context: context,
      defaultOnlineuser: defaultOnlineuser,
      matchDecisionRespJModelList: matchDecisionRespJModelList,
    );

    if (picked != null && picked != widget.selectedMatchDecisionRespJModel) {
      //CHECK PICKED OBJECT
      if (widget.onSelectedOnlineUserChanged != null) {
        if (await widget.onSelectedOnlineUserChanged(picked)) {
          widget.onChanged(picked);
          picked_Onlineuser = picked;
        } else {
          picked_Onlineuser = null;
        }
      } else {
        widget.onChanged(picked);
        picked_Onlineuser = picked;
      }
    }
    return picked_Onlineuser;
  }

  Future<MatchDecisionRespJModel> showMatchDecisionPickerOnline({
    BuildContext context,
    MatchDecisionRespJModel defaultOnlineuser,
    List<MatchDecisionRespJModel> matchDecisionRespJModelList,
  }) async {
    return await showDialog<MatchDecisionRespJModel>(
      context: context,
      builder: (BuildContext context) => _MatchDecisionPickerOnlineDialog(
        defaultOnlineuser: defaultOnlineuser,
        onlineusers: matchDecisionRespJModelList,
        suggestions_changed_NavigationDataBLoC:
            widget.suggestions_changed_NavigationDataBLoC,
      ),
    );
  }
}

class _MatchDecisionPickerOnlineDialog extends StatefulWidget {
  _MatchDecisionPickerOnlineDialog({
    Key key,
    this.defaultOnlineuser,
    this.onlineusers,
    this.suggestions_changed_NavigationDataBLoC,
  }) : super(key: key);
  MatchDecisionRespJModel defaultOnlineuser;
  List<MatchDecisionRespJModel> onlineusers;
  NavigationDataBLoC suggestions_changed_NavigationDataBLoC;
  @override
  State<StatefulWidget> createState() =>
      _MatchDecisionPickerOnlineDialogState();
}

class _MatchDecisionPickerOnlineDialogState
    extends State<_MatchDecisionPickerOnlineDialog>
    with AfterLayoutMixin<_MatchDecisionPickerOnlineDialog> {
  TextEditingController controller = new TextEditingController();
  String filter;
  TextStyle domTextStyle = TextStyle(
    fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
    fontSize: 14,
    letterSpacing: 0.0,
    color: DatingAppTheme.darkText,
  );
  NavigationDataBLoC on_sugList_Local_Changed_NavigationDataBLoC =
      NavigationDataBLoC();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    addListeners();
  }

  addListeners() {
    if (widget.suggestions_changed_NavigationDataBLoC != null) {
      widget.suggestions_changed_NavigationDataBLoC.stream_counter
          .listen((value) {
        NavigationData navigationData = value;
        if (navigationData != null &&
            navigationData.matchDecisionRespJModelList != null) {
          widget.onlineusers = navigationData.matchDecisionRespJModelList;
          refresh_WO_Data_NavigationDataBLoC(
              on_sugList_Local_Changed_NavigationDataBLoC);
        }
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: DatingAppTheme.transparent,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: DatingAppTheme.white,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: <Widget>[
                new Theme(
                  data: ThemeData(primaryColor: Theme.of(context).hintColor),
                  child: TextField(
                    decoration: new InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                            width: MediaQuery.of(context).size.width -
                                10 //Colors.white
                            ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor //Colors.white
                            ),
                      ),
                      hintText:
                          MaterialLocalizations.of(context).searchFieldLabel,
                      hintStyle: TextStyle(
                        fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
                        fontSize: 14,
                        letterSpacing: 0.0,
                        color: DatingAppTheme.pltf_grey,
                      ),
                      //domTextStyle, //new TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.search,
                        color: DatingAppTheme
                            .pltf_grey, //Theme.of(context).hintColor, //Colors.white,
                      ),
                      suffixIcon: filter == null || filter == ""
                          ? Container(
                              height: 0.0,
                              width: 0.0,
                            )
                          : InkWell(
                              child: Icon(Icons.clear,
                                  color:
                                      Theme.of(context).hintColor //Colors.white
                                  ),
                              onTap: () {
                                controller.clear();
                              },
                            ),
                    ),
                    style: domTextStyle,
                    controller: controller,
                    cursorColor:
                        DatingAppTheme.pltf_grey, //Theme.of(context).hintColor,
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    child: StreamBuilder(
                      stream: on_sugList_Local_Changed_NavigationDataBLoC
                          .stream_counter,
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: widget.onlineusers.length,
                          itemBuilder: (BuildContext context, int index) {
                            MatchDecisionRespJModel matchDecisionRespJModel =
                                widget.onlineusers[index];
                            if (filter == null ||
                                filter == "" ||
                                '${matchDecisionRespJModel.name}'
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())) {
                              return InkWell(
                                child: ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                              '${matchDecisionRespJModel.name}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  domTextStyle //new TextStyle(color: Colors.white),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(
                                      context, matchDecisionRespJModel);
                                },
                              );
                            }
                            return Container();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef OnSelectedItemchangedCallback = Future<bool> Function(
    MatchDecisionRespJModel selectedMatchDecisionRespJModel);

typedef ValidatorCallback = void Function(String val);

typedef OnClickedCallback = void Function();
