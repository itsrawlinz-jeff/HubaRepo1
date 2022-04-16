import 'dart:async';
import 'package:dating_app/Bloc/Streams/navdata/NavigationDataBLoC.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/users/CustomUserRespJModel.dart';
import 'package:dating_app/Models/ui/NavigationData.dart';
import 'package:dating_app/UI/Presentation/Themes/dating_app_theme.dart';
import 'package:dating_app/utils/data_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';

class CustomUserPickerOnline extends StatefulWidget {
  CustomUserPickerOnline({
    Key key,
    this.selectedCustomUserRespJModel,
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
    this.onlineuserList,
    this.selectedCustomUserRespJModelChanged_NavigationDataBLoC,
    this.functValidateTicket,
    this.isDisabled,
    this.hintText,
    this.onSelectedOnlineUserChanged,
    this.dropdownPadding,
    this.onClickedCallback,
    this.validateagainst,
    this.validateagainstChanged,
  }) : super(key: key);

  CustomUserRespJModel selectedCustomUserRespJModel;
  ValueChanged<CustomUserRespJModel> onChanged;
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
  List<CustomUserRespJModel> onlineuserList;
  NavigationDataBLoC selectedCustomUserRespJModelChanged_NavigationDataBLoC;
  NavigationDataBLoC validateagainstChanged;
  bool isDisabled;
  String hintText;
  OnSelectedItemchangedCallback onSelectedOnlineUserChanged;
  EdgeInsetsGeometry dropdownPadding;
  ValidatorCallback functValidateTicket;
  OnClickedCallback onClickedCallback;
  List<int> validateagainst;

  @override
  State<StatefulWidget> createState() => _CustomUserPickerOnlineState();
}

class _CustomUserPickerOnlineState extends State<CustomUserPickerOnline>
    with AfterLayoutMixin<CustomUserPickerOnline> {
  CustomUserRespJModel selectedCustomUserRespJModelStless = null;
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
    assignedTextEditingController.text = ((widget
                .selectedCustomUserRespJModel !=
            null
        ? '${((widget.selectedCustomUserRespJModel.first_name != null ? widget.selectedCustomUserRespJModel.first_name : '')) + ((isStringValid(widget.selectedCustomUserRespJModel.last_name) ? ' ${widget.selectedCustomUserRespJModel.last_name}' : ''))}'
        : ''));
    if (widget.selectedCustomUserRespJModel != null) {
      selectedCustomUserRespJModelStless = widget.selectedCustomUserRespJModel;
    } else {
      selectedCustomUserRespJModelStless = null;
    }
  }

  setUpListeners() {
    widget.selectedCustomUserRespJModelChanged_NavigationDataBLoC.stream_counter
        .listen((value) {
      NavigationData navigationData = value;
      if (navigationData != null) {
        widget.selectedCustomUserRespJModel =
            navigationData.customUserRespJModel;
        setUpData();
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return _renderDenseDisplay(context, selectedCustomUserRespJModelStless);
  }

  _renderDenseDisplay(
      BuildContext context, CustomUserRespJModel displayOnlineuser) {
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
                      style: ((widget.isDisabled != null && widget.isDisabled
                          ? datingAppThemeChanger
                              .selectedThemeData.txt_stl_f14w500_Med_pltf_grey
                          : datingAppThemeChanger
                              .selectedThemeData.txt_stl_f14w500_Med)),
                      cursorColor:
                          datingAppThemeChanger.selectedThemeData.cl_grey,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.person,
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
            _onselectOnlineuser(context, selectedCustomUserRespJModelStless,
                    widget.onlineuserList)
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
                  selectedCustomUserRespJModelStless = onValue;
                  widget.selectedCustomUserRespJModel =
                      selectedCustomUserRespJModelStless;
                  assignedTextEditingController
                      .text = ((selectedCustomUserRespJModelStless !=
                          null
                      ? '${((selectedCustomUserRespJModelStless.first_name != null ? selectedCustomUserRespJModelStless.first_name : '')) + ((isStringValid(selectedCustomUserRespJModelStless.last_name) ? ' ${selectedCustomUserRespJModelStless.last_name}' : ''))}'
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
    if (widget.isDisabled != null && widget.isDisabled) {
      return ((widget.dropdownPadding != null
          ? Padding(
              padding: widget.dropdownPadding,
              child: Icon(Icons.arrow_drop_down,
                  color: DatingAppTheme
                      .pltf_grey /*datingAppThemeChanger
                        .selectedThemeData.cl_real_grey_grey*/
                  ),
            )
          : Icon(Icons.arrow_drop_down,
              color: DatingAppTheme
                  .pltf_grey /*datingAppThemeChanger
                    .selectedThemeData.cl_real_grey_grey*/
              )));
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

    /*if (widget.isDisabled != null) {
      if (widget.isDisabled) {
        return ((widget.dropdownPadding != null
            ? Padding(
                padding: widget.dropdownPadding,
                child: Icon(Icons.arrow_drop_down,
                    color: DatingAppTheme.pltf_grey/*datingAppThemeChanger
                        .selectedThemeData.cl_real_grey_grey*/),
              )
            : Icon(Icons.arrow_drop_down,
                color: DatingAppTheme.pltf_grey/*datingAppThemeChanger
                    .selectedThemeData.cl_real_grey_grey*/)));
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
    }*/
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

  Future<CustomUserRespJModel> _onselectOnlineuser(
    BuildContext context,
    CustomUserRespJModel defaultOnlineuser,
    List<CustomUserRespJModel> onlineuserList,
  ) async {
    CustomUserRespJModel picked_Onlineuser = null;
    final CustomUserRespJModel picked = await showCustomUserPickerOnline(
      context: context,
      defaultOnlineuser: defaultOnlineuser,
      onlineuserList: onlineuserList,
    );

    if (picked != null && picked != widget.selectedCustomUserRespJModel) {
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
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

Future<CustomUserRespJModel> showCustomUserPickerOnline({
  BuildContext context,
  CustomUserRespJModel defaultOnlineuser,
  List<CustomUserRespJModel> onlineuserList,
}) async {
  return await showDialog<CustomUserRespJModel>(
    context: context,
    builder: (BuildContext context) => _CustomUserPickerOnlineDialog(
      defaultOnlineuser: defaultOnlineuser,
      onlineusers: onlineuserList,
    ),
  );
}

class _CustomUserPickerOnlineDialog extends StatefulWidget {
  _CustomUserPickerOnlineDialog({
    Key key,
    this.defaultOnlineuser,
    this.onlineusers,
  }) : super(key: key);
  CustomUserRespJModel defaultOnlineuser;
  List<CustomUserRespJModel> onlineusers;
  @override
  State<StatefulWidget> createState() => _CustomUserPickerOnlineDialogState();
}

class _CustomUserPickerOnlineDialogState
    extends State<_CustomUserPickerOnlineDialog> {
  TextEditingController controller = new TextEditingController();
  String filter;
  List<CustomUserRespJModel> onlineusers;
  TextStyle domTextStyle = TextStyle(
    fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
    fontSize: 14,
    letterSpacing: 0.0,
    color: DatingAppTheme.darkText,
  );

  @override
  void initState() {
    super.initState();
    onlineusers = widget.onlineusers;
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
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
                    child: ListView.builder(
                      itemCount: onlineusers.length,
                      itemBuilder: (BuildContext context, int index) {
                        CustomUserRespJModel customUserRespJModel =
                            onlineusers[index];
                        if (filter == null ||
                            filter == "" ||
                            '${((customUserRespJModel.first_name != null ? customUserRespJModel.first_name : '')) + ((isStringValid(customUserRespJModel.last_name) ? ' ${customUserRespJModel.last_name}' : ''))}'
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
                                          '${((customUserRespJModel.first_name != null ? customUserRespJModel.first_name : '')) + ((isStringValid(customUserRespJModel.last_name) ? ' ${customUserRespJModel.last_name}' : ''))}',
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
                              Navigator.pop(context, customUserRespJModel);
                            },
                          );
                        }
                        return Container();
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
    CustomUserRespJModel selectedCustomUserRespJModel);

typedef ValidatorCallback = void Function(String val);

typedef OnClickedCallback = void Function();
