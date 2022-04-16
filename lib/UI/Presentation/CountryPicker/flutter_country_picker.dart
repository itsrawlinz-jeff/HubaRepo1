import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'country.dart';
import 'package:diacritic/diacritic.dart';

export 'country.dart';

const _platform = const MethodChannel('biessek.rocks/flutter_country_picker');

Future<List<Country>> _fetchLocalizedCountryNames() async {
  List<Country> renamed = new List();
  Map result;
  try {
    var isoCodes = <String>[];
    Country.ALL.forEach((Country country) {
      isoCodes.add(country.isoCode);
    });
    result = await _platform.invokeMethod(
        'getCountryNames', <String, dynamic>{'isoCodes': isoCodes});
  } on PlatformException catch (e) {
    return Country.ALL;
  }

  for (var country in Country.ALL) {
    renamed.add(country.copyWith(name: result[country.isoCode]));
  }
  renamed.sort(
      (Country a, Country b) => removeDiacritics(a.name).compareTo(b.name));

  return renamed;
}

/// The country picker widget exposes an dialog to select a country from a
/// pre defined list, see [Country.ALL]
class CountryPicker extends StatefulWidget {
  const CountryPicker({
    Key key,
    this.selectedCountry,
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
  }) : super(key: key);

  final Country selectedCountry;
  final ValueChanged<Country> onChanged;
  final bool dense;
  final bool showFlag;
  final bool showDialingCode;
  final bool showName;
  final bool showCurrency;
  final bool showCurrencyISO;
  final TextStyle nameTextStyle;
  final TextStyle dialingCodeTextStyle;
  final TextStyle currencyTextStyle;
  final TextStyle currencyISOTextStyle;

  @override
  State<StatefulWidget> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  Country selectedCountryStless = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    Country displayCountry = null;
    if (selectedCountryStless != null) {
      displayCountry = selectedCountryStless;
    } else {
      displayCountry = widget.selectedCountry;
    }

    if (displayCountry == null) {
      displayCountry =
          Country.findByIsoCode(Localizations.localeOf(context).countryCode);
    }

    print('selectedcountry DEF==${displayCountry.name}');
    setState(() {
      selectedCountryStless = displayCountry;
    });

    return widget.dense
        ? _renderDenseDisplay(context, displayCountry)
        : _renderDefaultDisplay(context, displayCountry);
  }

  _renderDefaultDisplay(BuildContext context, Country displayCountry) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (widget.showFlag)
            Container(
                child: Image.asset(
              selectedCountryStless.asset,
              //package: "dating_app",
              height: 32.0,
              fit: BoxFit.fitWidth,
            )),
          if (widget.showName)
            Container(
                child: Text(
              " ${selectedCountryStless.name}",
              style: widget.nameTextStyle,
            )),
          if (widget.showDialingCode)
            Container(
                child: Text(
              " (+${selectedCountryStless.dialingCode})",
              style: widget.dialingCodeTextStyle,
            )),
          if (widget.showCurrency)
            Container(
                child: Text(
              " ${selectedCountryStless.currency}",
              style: widget.currencyTextStyle,
            )),
          if (widget.showCurrencyISO)
            Container(
                child: Text(
              " ${selectedCountryStless.currencyISO}",
              style: widget.currencyISOTextStyle,
            )),
          Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade200
                  : Colors.white70),
        ],
      ),
      onTap: () {
        // _selectCountry(context, selectedCountryStless);
        _onselectCountry(context, selectedCountryStless).then((onValue) {
          print('_onselectCountry1=${onValue.name}');
          setState(() {
            selectedCountryStless = onValue;
          });
        }, onError: (error) {});
      },
    );
  }

  _renderDenseDisplay(BuildContext context, Country displayCountry) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            selectedCountryStless.asset,
            //package: "flutter_country_picker",
            height: 24.0,
            fit: BoxFit.fitWidth,
          ),
          Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade200
                  : Colors.white70),
        ],
      ),
      onTap: () {
        // _selectCountry(context, displayCountry).then((onValue) {
        _onselectCountry(context, selectedCountryStless).then((onValue) {
          print('_onselectCountry2=${onValue.name}');
          setState(() {
            selectedCountryStless = onValue;
          });
        }, onError: (error) {});
      },
    );
  }

  Future<Country> _onselectCountry(
      BuildContext context, Country defaultCountry) async {
    Country picked_Country = null;
    final Country picked = await showCountryPicker(
      context: context,
      defaultCountry: defaultCountry,
    );

    if (picked != null && picked != widget.selectedCountry) {
      widget.onChanged(picked);
      print('_onselectCountry picked ${picked.name}');
      picked_Country = picked;
    }
    return picked_Country;
  }

  Future<Null> _selectCountry(
      BuildContext context, Country defaultCountry) async {
    final Country picked = await showCountryPicker(
      context: context,
      defaultCountry: defaultCountry,
    );

    if (picked != null && picked != widget.selectedCountry) {
      widget.onChanged(picked);
      print('picked ${picked.name}');
    }
  }
}

/// Display a [Dialog] with the country list to selection
/// you can pass and [defaultCountry], see [Country.findByIsoCode]
Future<Country> showCountryPicker({
  BuildContext context,
  Country defaultCountry,
}) async {
  assert(Country.findByIsoCode(defaultCountry.isoCode) != null);

  return await showDialog<Country>(
    context: context,
    builder: (BuildContext context) => _CountryPickerDialog(
      defaultCountry: defaultCountry,
    ),
  );
}

class _CountryPickerDialog extends StatefulWidget {
  const _CountryPickerDialog({
    Key key,
    Country defaultCountry,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<_CountryPickerDialog> {
  TextEditingController controller = new TextEditingController();
  String filter;
  List<Country> countries;

  @override
  void initState() {
    super.initState();

    countries = Country.ALL;

/*    _fetchLocalizedCountryNames().then((renamed) {
      setState(() {
        countries = renamed;
      });
    });*/

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
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.4, 0.7, 0.9],
                colors: [
                  Color(0xFF3594DD),
                  Color(0xFF4563DB),
                  Color(0xFF5036D5),
                  Color(0xFF5B16D0),
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                new TextField(
                  decoration: new InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText:
                        MaterialLocalizations.of(context).searchFieldLabel,
                    hintStyle: new TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    suffixIcon: filter == null || filter == ""
                        ? Container(
                            height: 0.0,
                            width: 0.0,
                          )
                        : InkWell(
                            child: Icon(Icons.clear, color: Colors.white),
                            onTap: () {
                              controller.clear();
                            },
                          ),
                  ),
                  controller: controller,
                ),
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: countries.length,
                      itemBuilder: (BuildContext context, int index) {
                        Country country = countries[index];
                        if (filter == null ||
                            filter == "" ||
                            country.name
                                .toLowerCase()
                                .contains(filter.toLowerCase()) ||
                            country.isoCode.contains(filter)) {
                          return InkWell(
                            child: ListTile(
                              trailing: Text(
                                "+ ${country.dialingCode}",
                                style: new TextStyle(color: Colors.white),
                              ),
                              title: Row(
                                children: <Widget>[
                                  Image.asset(
                                    country.asset,
                                    //package: "flutter_country_picker",
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        country.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            new TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context, country);
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
