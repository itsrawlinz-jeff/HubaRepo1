import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DatingAppTheme {
  DatingAppTheme._();
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static Color nearlyDarkBlue = HexColor('#1E22AA'); //Color(0xFF2633C5);
  static Color blue_1 = HexColor('#A9BCFA');
  static Color blue_red_1 = HexColor('#B99ACD');
  static Color blue_red_2 = HexColor('#C089B6');
  static Color green_open = HexColor('#4DBD74');
  static Color red_closed = HexColor('#F86C6B');
  static Color yellow_in_progress = HexColor('#FFC107');
  //PLATFORM COLORS
  static Color pltf_grey = Color(0xFF9E9E9E);
  static Color pltf_pink = Color(0xFFE91E63);

  //END OF PLATFORM COLORS

  static const Color nearlyWhite_1 = Color(0xFFFEFEFE);
  static Color dark_red = HexColor('#4C0805');
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color black = Color(0xFF000000);

  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color white_grey_1 = Color(0xFFFFF0F5);

  static const Color real_grey = Colors.grey;
  static const Color grey_border_1 = Color(0xFFE4E6EC);
  static const Color grey_prof_page_bg_2 = Color(0xFFF5F4F6);
  static const Color grey_prof_item_bg_3 = Color(0xFFEAEDF1);
  static const Color grey_prof_appbar_bg_4 = Color(0xFFFFFEFF);
  static const Color grey_placeholder = Color(0xFFEAEDF2);

  static const Color real_pink = Colors.pink;
  static const Color pink3 = Color(0xFFF8BBD0);
  static const Color pink4 = Color(0xFFE16B6D);
  static const Color pink5 = Color(0xFFFE277C);
  static const Color pink6 = Color(0xFFFF7856);
  static const Color pink7 = Color(0xFFFE5964);
  static const Color pink8 = Color(0xFFA42EB8);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color red = Color(0xFFF44336);
  static const Color redBackground = Color.fromRGBO(255, 207, 207, 1);
  static const Color yellow_C1 = Color(0xFFF1B440);
  static const Color yellow_C2 = Color(0xFFFF8503);
  static const Color red_C1 = Color(0xFFF56E98);
  static const Color green = Colors.green;
  static const Color bg_Grey1 = Color(0xFFF8FAFB);
  static const Color transparent = Colors.transparent;
  static const Color darkBrown1 = Color(0xFFFF7E00);
  static const Color bg_Grey2 = Color(0xFFDCDCDC);
  static const Color bg_Grey3 = Color(0xFFE3E1E3);
  static const Color grey_Disabled = Color(0xFFA6A5A7);
  static const Color pink1 = Color(0xFFFA7D82);
  static const Color pink2 = Color(0xFFB66680);

  static const Color ks_black_7 = Color(0xFF252A34);
  static const Color ks_black_1 = Color(0xFF252833);
  static const Color ks_red_1 = Color(0xFFF61434);

  static const Color black_33 = Color(0x33000000);
  static const Color black_40 = Color(0x40000000);
  static const Color black_4D = Color(0x4D000000);
  static const Color black_66 = Color(0x66000000);
  static const Color black_99 = Color(0x99000000);
  static const Color black_CC = Color(0xCC000000);
  static const Color black_1 = Color(0xff23242D);

  static const Color adrianRed_1 = Color(0xFFF8B9CD);
  static const Color adrianRed_2 = Color(0xFFF5A2BC);
  static const Color adrianRed_3 = Color(0xFFF38BAB);
  static const Color adrianRed_4 = Color(0xFFEB4678);
  static const Color adrianRed_5 = Color(0xFFFDE8EE);
  static const Color adrianRed_6 = Color(0xFFFAD1DD);
  static const Color adrianRed_7 = Color(0xFFF8B9CD);

  static Color colorAdrianBlue = HexColor('#1E22AA');
  static const Color colorAdrianBlue_cl = Color(0xFF1E22AA);
  static Color colorAdrianRed = HexColor('#E40046');
  static const Color notificationBadgeColor = const Color(0xff08d160);

  static const Color grey_iconColor = const Color(0xff858b90);

  static Map<int, Color> coloMap = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  static MaterialColor mt_colorAdrianRed = MaterialColor(0xFFE40046, coloMap);

  static const String fontName = 'Roboto';
  static const String font_WorkSans = 'WorkSans';

  //AVENIR
  static const String font_AvenirLTStd_Black = 'AvenirLTStd-Black';
  static const String font_AvenirLTStd_BlackOblique =
      'AvenirLTStd-BlackOblique';
  static const String font_AvenirLTStd_Book = 'AvenirLTStd-Book';
  static const String font_AvenirLTStd_BookOblique = 'AvenirLTStd-BookOblique';
  static const String font_AvenirLTStd_Heavy = 'AvenirLTStd-Heavy';
  static const String font_AvenirLTStd_HeavyOblique =
      'AvenirLTStd-HeavyOblique';
  static const String font_AvenirLTStd_Light = 'AvenirLTStd-Light';
  static const String font_AvenirLTStd_LightOblique =
      'AvenirLTStd-LightOblique';
  static const String font_AvenirLTStd_Medium = 'AvenirLTStd-Medium';
  static const String font_AvenirLTStd_MediumOblique =
      'AvenirLTStd-MediumOblique';
  static const String font_AvenirLTStd_Oblique = 'AvenirLTStd-Oblique';
  static const String font_AvenirLTStd_Roman = 'AvenirLTStd-Roman';

  static const TextTheme textTheme = TextTheme(
    display1: display1,
    headline: headline,
    title: title,
    subtitle: subtitle,
    body2: body2,
    body1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

  static TextTheme _buildTextTheme(TextTheme base) {
    const String fontName = 'WorkSans';
    return base.copyWith(
      title: base.title.copyWith(fontFamily: fontName),
      body1: base.title.copyWith(fontFamily: fontName),
      body2: base.title.copyWith(fontFamily: fontName),
      button: base.title.copyWith(fontFamily: fontName),
      caption: base.title.copyWith(fontFamily: fontName),
      display1: base.title.copyWith(fontFamily: fontName),
      display2: base.title.copyWith(fontFamily: fontName),
      display3: base.title.copyWith(fontFamily: fontName),
      display4: base.title.copyWith(fontFamily: fontName),
      headline: base.title.copyWith(fontFamily: fontName),
      overline: base.title.copyWith(fontFamily: fontName),
      subhead: base.title.copyWith(fontFamily: fontName),
      subtitle: base.title.copyWith(fontFamily: fontName),
    );
  }

  static ThemeData buildLightTheme() {
    final Color primaryColor = HexColor('#54D3C2');
    final Color secondaryColor = HexColor('#54D3C2');
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      backgroundColor: const Color(0xFFFFFFFF),
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      errorColor: const Color(0xFFB00020),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS,
    );
  }

  static TextStyle auth_Btns_TextStyle = TextStyle(
    fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    letterSpacing: 0.0,
    color: DatingAppTheme.white,
  );
  static TextStyle txt_Part1_TextStyle = TextStyle(
      fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0.0,
      color: DatingAppTheme.grey.withOpacity(0.8));

  static TextStyle txt_Part2_TextStyle = TextStyle(
      fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0.0,
      color: DatingAppTheme.colorAdrianBlue.withOpacity(0.8));

  static TextStyle auth_hint_TextStyle = TextStyle(
    fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.0,
    color: DatingAppTheme.grey,
  );

  static TextStyle auth_txt_FieldTextStyle = TextStyle(
    fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.0,
    color: DatingAppTheme.grey,
  );

  static TextStyle auth_error_TextStyle = TextStyle(
    fontFamily: DatingAppTheme.font_AvenirLTStd_Light,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    letterSpacing: 0.0,
    color: DatingAppTheme.colorAdrianRed,
  );

  static TextStyle txt_CountryList_TextStyle = TextStyle(
    fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.0,
  );
  static TextStyle txt_OTP_TextStyle = TextStyle(
    fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
    fontWeight: FontWeight.w500,
    fontSize: 24.0,
    color: Colors.black,
    letterSpacing: 0.0,
  );

  static TextStyle txt_snackbar_TextStyle = TextStyle(
    fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.0,
    color: DatingAppTheme.white,
  );

  static TextStyle sm_Username = TextStyle(
    fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
    fontWeight: FontWeight.w600,
    color: DatingAppTheme.darkText,
    fontSize: 14,
  );

  static TextStyle get_sm_Username() {
    return sm_Username = TextStyle(
      fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
      fontWeight: FontWeight.w600,
      color: DatingAppTheme.darkText,
      fontSize: 14,
    );
  }

  bool isDarkTheme() {
    return false;
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class DatingAppSelectedTheme {
  DatingAppSelectedTheme._();

  static SelectedThemeData get_themeData(bool isDarkTheme) {
    print('getCurrentTheme get_themeData isDarkTheme==${isDarkTheme}');
    return SelectedThemeData(
      txt_stl_whitegrey_13_Book: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.normal,
              fontSize: 13,
              letterSpacing: -0.2,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.normal,
              fontSize: 13,
              letterSpacing: -0.2,
              color: DatingAppTheme.grey,
            ),
      loginpage_hintStyle: isDarkTheme
          ? TextStyle(
              color: DatingAppTheme.dark_grey,
              fontSize: 16.0,
              fontFamily: DatingAppTheme.font_AvenirLTStd_LightOblique,
            )
          : TextStyle(
              color: DatingAppTheme.white,
              fontSize: 16.0,
              fontFamily: DatingAppTheme.font_AvenirLTStd_LightOblique,
            ),
      loginpage_FormField_TextStyle: isDarkTheme
          ? TextStyle(
              fontSize: 16.0,
              color: DatingAppTheme.dark_grey,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Light,
            )
          : TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Light,
            ),
      loginpage_LoginBtn_TextStyle: isDarkTheme
          ? TextStyle(
              fontSize: 16.0,
              color: DatingAppTheme.dark_grey,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
            )
          : TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
            ),
      loginpage_ForgotYourPassword_TextStyle: isDarkTheme
          ? TextStyle(
              color: DatingAppTheme.dark_grey,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
            )
          : TextStyle(
              color: Colors.white,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
            ),
      loginpage_SignInWith_TextStyle: isDarkTheme
          ? TextStyle(
              color: DatingAppTheme.dark_grey,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Light,
            )
          : TextStyle(
              color: Colors.white,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Light,
            ),
      login_error_TextStyle: TextStyle(
          color: DatingAppTheme.white_grey_1,
          fontFamily: DatingAppTheme.font_AvenirLTStd_Light),
      default_label_TextStyle: TextStyle(
          color: DatingAppTheme.darkText,
          fontSize: 14.0,
          fontFamily: DatingAppTheme.font_AvenirLTStd_Medium),
      default_hint_TextStyle: TextStyle(
          color: DatingAppTheme.darkText,
          fontSize: 14.0,
          fontFamily: DatingAppTheme.font_AvenirLTStd_Light),
      default_text_TextStyle: TextStyle(
          color: DatingAppTheme.black,
          fontSize: 14.0,
          fontFamily: DatingAppTheme.font_AvenirLTStd_Book),
      default_error_TextStyle: TextStyle(
          color: DatingAppTheme.red,
          fontSize: 12.0,
          fontFamily: DatingAppTheme.font_AvenirLTStd_Light),
      default_bgTitleText_TextStyle: TextStyle(
        fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
        fontWeight: FontWeight.w500,
        fontSize: 28,
        letterSpacing: 0.5,
        color: DatingAppTheme.lightText,
      ),
      default_description_TextStyle: TextStyle(
        fontSize: 11,
        color: DatingAppTheme.lightText,
        fontFamily: DatingAppTheme.font_AvenirLTStd_Light,
      ),
      default_swp_left_To_Cont_TextStyle: TextStyle(
        fontSize: 15,
        color: DatingAppTheme.lightText,
        fontWeight: FontWeight.w500,
        fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
      ),
      auth_Btns_TextStyle: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              letterSpacing: 0.0,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              letterSpacing: 0.0,
              color: DatingAppTheme.black,
            ),
      title_TextStyle: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              letterSpacing: 0.5,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              letterSpacing: 0.5,
              color: DatingAppTheme.lightText,
            ),
      sm_Username: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontWeight: FontWeight.w600,
              color: DatingAppTheme.white,
              fontSize: 14,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontWeight: FontWeight.w600,
              color: DatingAppTheme.darkText,
              fontSize: 14,
            ),
      sm_bg_background:
          isDarkTheme ? Color(0xFF000000) : Color(0xFFF2F3F8).withOpacity(0.5),
      sm_bg_background_WOpacity:
          isDarkTheme ? Color(0xFF000000) : Color(0xFFF2F3F8),
      sm_bg_backgroundWO_opacity:
          isDarkTheme ? Color(0xFF000000) : Color(0xFFF2F3F8),
      txt_adrGrayO5_Color:
          isDarkTheme ? Colors.white : DatingAppTheme.grey.withOpacity(0.5),
      sm_txt_Color: isDarkTheme ? Color(0xFFFFFFFF) : Color(0xFF253840),
      sm_currentIndex_txt_Color:
          isDarkTheme ? Color(0xFFFA7D82) : DatingAppTheme.nearlyDarkBlue,
      sm_moon_sun_bg_Color: isDarkTheme ? Color(0x33FA7D82) : Colors.white,
      mnu_Color: isDarkTheme ? Colors.white : DatingAppTheme.lightText,
      mnu_grey_Color: isDarkTheme ? Colors.white : DatingAppTheme.grey,
      txt_darkText_Color: isDarkTheme ? Colors.white : DatingAppTheme.darkText,
      mnu_darkerText_Color:
          isDarkTheme ? Colors.white : DatingAppTheme.darkerText,
      mnu_topbar_Bg: isDarkTheme ? HexColor('253840') : DatingAppTheme.white,
      normal_TextStyle:
          isDarkTheme ? HexColor('4C0805') : DatingAppTheme.darkerText,
      selectedThemeBaseColor:
          isDarkTheme ? Color(0xFF000000) : DatingAppTheme.white,
      hm_Background:
          isDarkTheme ? Color(0xFF000000) : DatingAppTheme.nearlyWhite_1,
      white_box_Background:
          isDarkTheme ? DatingAppTheme.adrianRed_4 : DatingAppTheme.white,
      bg_task_Item: isDarkTheme ? DatingAppTheme.black_1 : DatingAppTheme.white,
      black_White: isDarkTheme ? DatingAppTheme.black : DatingAppTheme.white,
      bg_WaterDrop: isDarkTheme ? DatingAppTheme.pink1 : DatingAppTheme.white,
      cl_grey: isDarkTheme ? DatingAppTheme.white : DatingAppTheme.grey,
      cl_bg_Grey2_grey:
          isDarkTheme ? DatingAppTheme.bg_Grey2 : DatingAppTheme.grey,
      cl_real_grey_grey:
          isDarkTheme ? DatingAppTheme.real_grey : DatingAppTheme.grey,
      cl_grey_splash:
          isDarkTheme ? DatingAppTheme.black_1 : DatingAppTheme.grey,
      cl_WaterDrop: isDarkTheme
          ? DatingAppTheme.colorAdrianBlue_cl
          : DatingAppTheme.colorAdrianBlue_cl,
      cl_LogoutDialog:
          isDarkTheme ? DatingAppTheme.white : DatingAppTheme.nearlyDarkBlue,
      cl_dismissibleBackground_white: isDarkTheme
          ? DatingAppTheme.dismissibleBackground
          : DatingAppTheme.white,
      ts_sub_tsk_sub_hdr: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              fontSize: 16,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              fontSize: 16,
              color: DatingAppTheme.lightText,
            ),
      ts_chk_day: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: -0.1,
              color: DatingAppTheme.white)
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: -0.1,
              color: DatingAppTheme.darkText),
      txt_stl_f14w500_Med: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.darkText,
            ),
      txt_stl_f14w500_Med_pltf_grey: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.pltf_grey,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.pltf_grey,
            ),
      txt_stl_hint_f14w500_Med: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.darkText,
            ),
      txt_stl_hint_f14w500_Med_pltf_grey: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.pltf_grey,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.pltf_grey,
            ),
      txt_stl_white_white_f22_Heavy: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontSize: 22.0,
              color: Colors.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontSize: 22.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      txt_stl_white_white_f14_Heavy: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
      app_background:
          isDarkTheme ? DatingAppTheme.white : DatingAppTheme.background,
      cl_WhiteOpacity_08: isDarkTheme
          ? DatingAppTheme.white
          : DatingAppTheme.white.withOpacity(0.8),
      cl_sel_btm_Itm:
          isDarkTheme ? DatingAppTheme.pink2 : DatingAppTheme.nearlyDarkBlue,
      txt_stl_save: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.0,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.0,
              color: DatingAppTheme.grey,
            ),
      txt_stl_black_14_med: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: DatingAppTheme.black,
            ),
      txt_stl_lighttext_14_reg: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: DatingAppTheme.lightText,
            ),
      txt_stl_lighttext_15_heav: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: DatingAppTheme.lightText,
            ),
      txt_stl_darkText_15_heav_ls0_2: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              letterSpacing: -0.2,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Heavy,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              letterSpacing: -0.2,
              color: DatingAppTheme.darkText,
            ),
      txt_stl_black_99_13_book_ls0_2: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              letterSpacing: -0.2,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              letterSpacing: -0.2,
              color: DatingAppTheme.black_99,
            ),
      txt_stl_whitedarkerText_15_Med: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.normal,
              fontSize: 15,
              letterSpacing: -0.2,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.normal,
              fontSize: 15,
              letterSpacing: -0.2,
              color: DatingAppTheme.darkerText,
            ),
      txt_stl_whitegrey_14_Med: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.grey,
            ),
      txt_stl_whitegrey_14_Med_pltf_grey: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.pltf_grey,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.pltf_grey,
            ),
      txt_stl_obl_whitegrey_14_Med_pltf_grey: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Oblique,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Oblique,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.pltf_grey,
            ),
      txt_stl_white_pltf_grey_16_Med_700: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: 0.0,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: 0.0,
              color: DatingAppTheme.pltf_grey,
            ),
      cl_darkerText_bg_Grey3:
          isDarkTheme ? DatingAppTheme.darkerText : DatingAppTheme.bg_Grey3,
      cl_white_grey: isDarkTheme ? DatingAppTheme.white : DatingAppTheme.grey,
      cl_real_grey_grey_Disabled:
          isDarkTheme ? DatingAppTheme.real_grey : DatingAppTheme.grey_Disabled,
      cl_colorAdrianBlue_white:
          isDarkTheme ? DatingAppTheme.white : DatingAppTheme.colorAdrianBlue,
      txt_stl_white_grey_14_w500_sp0_Med: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.grey,
            ),
      txt_stl_pink1_nearlyDarkBlue_14_w500_sp0_Med: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.pink1,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.nearlyDarkBlue,
            ),
      txt_stl_white_grey05_10_w500_sp0_Med: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.w500,
              fontSize: 10,
              letterSpacing: 0.0,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Book,
              fontWeight: FontWeight.w500,
              fontSize: 10,
              letterSpacing: 0.0,
              color: DatingAppTheme.grey.withOpacity(0.5),
            ),
      cl_white_nearlyDarkBlue:
          isDarkTheme ? DatingAppTheme.white : DatingAppTheme.nearlyDarkBlue,
      txt_stl_white_grey_14_wbold_sp0_Med: isDarkTheme
          ? TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.0,
              color: DatingAppTheme.grey,
            ),
      cl_white_black: isDarkTheme ? DatingAppTheme.white : Colors.black,
      default_UnSel_ClickableItem_TextStyle: isDarkTheme
          ? TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.27,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              color: DatingAppTheme.real_pink,
            )
          : TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.27,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              color: DatingAppTheme.darkerText,
            ),
      default_Sel_ClickableItem_TextStyle: isDarkTheme
          ? TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.27,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              color: DatingAppTheme.white,
            )
          : TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.27,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Medium,
              color: DatingAppTheme.white,
            ),
      cl_cont_Sel_ClickableItem:
          isDarkTheme ? DatingAppTheme.real_pink : DatingAppTheme.green_open,
      cl_cont_UnSel_ClickableItem:
          isDarkTheme ? DatingAppTheme.pink3 : DatingAppTheme.white,
      cl_cont_Sel_ClickableItem_Bshadow:
          isDarkTheme ? DatingAppTheme.white : DatingAppTheme.transparent,
      cl_cont_UnSel_ClickableItem_Bshadow: isDarkTheme
          ? Colors.black.withOpacity(.12)
          : Colors.black.withOpacity(.12),
      cl_pgind_Sel:
          isDarkTheme ? DatingAppTheme.pink3 : DatingAppTheme.darkerText,
      cl_pgind_UnSel:
          isDarkTheme ? DatingAppTheme.white : DatingAppTheme.green_open,
      cl_Checkbox_Item:
          isDarkTheme ? DatingAppTheme.white : DatingAppTheme.darkerText,
      cl_save_Btn: isDarkTheme ? DatingAppTheme.pink3 : DatingAppTheme.white,
      cl_icon_col_save_Btn: isDarkTheme ? Colors.white : DatingAppTheme.grey,
      cl_appbar_icon_pink:
          isDarkTheme ? DatingAppTheme.pink4 : DatingAppTheme.pink4,
      cl_profile_item_border: isDarkTheme
          ? DatingAppTheme.grey_border_1
          : DatingAppTheme.grey_border_1,
      cl_profile_item_bg: isDarkTheme
          ? DatingAppTheme.grey_prof_item_bg_3
          : DatingAppTheme.grey_prof_item_bg_3,
      cl_profile_page_bg: isDarkTheme
          ? DatingAppTheme.grey_prof_page_bg_2
          : DatingAppTheme.grey_prof_page_bg_2,
      txt_stl_error_f12_Light: isDarkTheme
          ? TextStyle(
              color: DatingAppTheme.colorAdrianRed,
              fontSize: 12.0,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Light)
          : TextStyle(
              color: DatingAppTheme.colorAdrianRed,
              fontSize: 12.0,
              fontFamily: DatingAppTheme.font_AvenirLTStd_Light),
      cl_darkText_backgroundcolor:
          isDarkTheme ? DatingAppTheme.darkText : DatingAppTheme.background,
      cl_grey_op_06: isDarkTheme
          ? Colors.grey.withOpacity(0.6)
          : Colors.grey.withOpacity(0.6),
      cl_grey_op_04: isDarkTheme
          ? Colors.grey.withOpacity(0.6)
          : Colors.grey.withOpacity(0.4),
    );
  }

  static SelectedThemeData get_default_AppthemeData() {
    return get_themeData(false);
  }
}

class SelectedThemeData {
  SelectedThemeData({
    this.auth_Btns_TextStyle,
    this.title_TextStyle,
    this.sm_Username,
    this.sm_bg_background,
    this.sm_txt_Color,
    this.sm_currentIndex_txt_Color,
    this.sm_moon_sun_bg_Color,
    this.mnu_Color,
    this.mnu_grey_Color,
    this.mnu_darkerText_Color,
    this.mnu_topbar_Bg,
    this.normal_TextStyle,
    this.selectedThemeBaseColor,
    this.hm_Background,
    this.white_box_Background,
    this.txt_darkText_Color,
    this.txt_adrGrayO5_Color,
    this.bg_task_Item,
    this.black_White,
    this.bg_WaterDrop,
    this.cl_WaterDrop,
    this.cl_LogoutDialog,
    this.ts_sub_tsk_sub_hdr,
    this.ts_chk_day,
    this.app_background,
    this.txt_stl_f14w500_Med,
    this.txt_stl_hint_f14w500_Med,
    this.txt_stl_hint_f14w500_Med_pltf_grey,
    this.cl_grey,
    this.cl_WhiteOpacity_08,
    this.cl_grey_splash,
    this.cl_sel_btm_Itm,
    this.txt_stl_save,
    this.cl_dismissibleBackground_white,
    this.txt_stl_black_14_med,
    this.txt_stl_lighttext_14_reg,
    this.txt_stl_lighttext_15_heav,
    this.txt_stl_whitedarkerText_15_Med,
    this.txt_stl_whitegrey_14_Med,
    this.cl_darkerText_bg_Grey3,
    this.cl_bg_Grey2_grey,
    this.cl_real_grey_grey,
    this.cl_white_grey,
    this.cl_real_grey_grey_Disabled,
    this.txt_stl_darkText_15_heav_ls0_2,
    this.txt_stl_black_99_13_book_ls0_2,
    this.cl_colorAdrianBlue_white,
    this.txt_stl_white_grey_14_w500_sp0_Med,
    this.txt_stl_white_grey05_10_w500_sp0_Med,
    this.txt_stl_pink1_nearlyDarkBlue_14_w500_sp0_Med,
    this.cl_white_nearlyDarkBlue,
    this.txt_stl_white_grey_14_wbold_sp0_Med,
    this.cl_white_black,
    this.default_label_TextStyle,
    this.default_hint_TextStyle,
    this.default_text_TextStyle,
    this.default_error_TextStyle,
    this.default_bgTitleText_TextStyle,
    this.default_description_TextStyle,
    this.default_Sel_ClickableItem_TextStyle,
    this.default_UnSel_ClickableItem_TextStyle,
    this.cl_cont_Sel_ClickableItem,
    this.cl_cont_UnSel_ClickableItem,
    this.cl_cont_Sel_ClickableItem_Bshadow,
    this.cl_cont_UnSel_ClickableItem_Bshadow,
    this.cl_pgind_Sel,
    this.cl_pgind_UnSel,
    this.cl_Checkbox_Item,
    this.cl_save_Btn,
    this.cl_icon_col_save_Btn,
    this.sm_bg_backgroundWO_opacity,
    this.txt_stl_white_white_f22_Heavy,
    this.txt_stl_white_white_f14_Heavy,
    this.cl_appbar_icon_pink,
    this.cl_profile_item_border,
    this.cl_profile_item_bg,
    this.cl_profile_page_bg,
    this.default_swp_left_To_Cont_TextStyle,
    this.sm_bg_background_WOpacity,
    this.txt_stl_error_f12_Light,
    this.cl_darkText_backgroundcolor,
    this.loginpage_hintStyle,
    this.loginpage_FormField_TextStyle,
    this.loginpage_LoginBtn_TextStyle,
    this.loginpage_ForgotYourPassword_TextStyle,
    this.loginpage_SignInWith_TextStyle,
    this.login_error_TextStyle,
    this.txt_stl_whitegrey_13_Book,
    this.txt_stl_whitegrey_14_Med_pltf_grey,
    this.txt_stl_obl_whitegrey_14_Med_pltf_grey,
    this.txt_stl_f14w500_Med_pltf_grey,
    this.cl_grey_op_06,
    this.cl_grey_op_04,
    this.txt_stl_white_pltf_grey_16_Med_700,
  });
  TextStyle auth_Btns_TextStyle;
  TextStyle title_TextStyle;
  TextStyle sm_Username;
  Color sm_bg_background;
  Color sm_txt_Color;
  Color sm_currentIndex_txt_Color;
  Color sm_moon_sun_bg_Color;
  Color mnu_Color;
  Color mnu_grey_Color;
  Color mnu_darkerText_Color;
  Color mnu_topbar_Bg;
  Color normal_TextStyle;
  Color selectedThemeBaseColor;
  Color hm_Background;
  Color white_box_Background;
  Color txt_darkText_Color;
  Color txt_adrGrayO5_Color;
  Color bg_task_Item;
  Color black_White;
  Color bg_WaterDrop;
  Color cl_WaterDrop;
  Color cl_LogoutDialog;
  TextStyle ts_sub_tsk_sub_hdr;
  TextStyle ts_chk_day;
  Color app_background;
  TextStyle txt_stl_f14w500_Med;
  TextStyle txt_stl_hint_f14w500_Med;
  TextStyle txt_stl_hint_f14w500_Med_pltf_grey;
  Color cl_grey;
  Color cl_WhiteOpacity_08;
  Color cl_grey_splash;
  Color cl_sel_btm_Itm;
  TextStyle txt_stl_save;
  Color cl_dismissibleBackground_white;
  TextStyle txt_stl_black_14_med;
  TextStyle txt_stl_lighttext_14_reg;
  TextStyle txt_stl_lighttext_15_heav;
  TextStyle txt_stl_whitedarkerText_15_Med;
  TextStyle txt_stl_whitegrey_14_Med;
  TextStyle txt_stl_whitegrey_14_Med_grey;
  Color cl_darkerText_bg_Grey3;
  Color cl_bg_Grey2_grey;
  Color cl_real_grey_grey;
  Color cl_white_grey;
  Color cl_real_grey_grey_Disabled;
  TextStyle txt_stl_darkText_15_heav_ls0_2;
  TextStyle txt_stl_black_99_13_book_ls0_2;
  Color cl_colorAdrianBlue_white;
  TextStyle txt_stl_white_grey_14_w500_sp0_Med;
  TextStyle txt_stl_white_grey05_10_w500_sp0_Med;
  TextStyle txt_stl_pink1_nearlyDarkBlue_14_w500_sp0_Med;
  Color cl_white_nearlyDarkBlue;
  TextStyle txt_stl_white_grey_14_wbold_sp0_Med;
  Color cl_white_black;
  TextStyle default_label_TextStyle;
  TextStyle default_hint_TextStyle;
  TextStyle default_text_TextStyle;
  TextStyle default_error_TextStyle;
  TextStyle default_bgTitleText_TextStyle;
  TextStyle default_description_TextStyle;
  TextStyle default_Sel_ClickableItem_TextStyle;
  TextStyle default_UnSel_ClickableItem_TextStyle;
  Color cl_cont_Sel_ClickableItem;
  Color cl_cont_UnSel_ClickableItem;

  Color cl_cont_Sel_ClickableItem_Bshadow;
  Color cl_cont_UnSel_ClickableItem_Bshadow;
  Color cl_pgind_Sel;
  Color cl_pgind_UnSel;
  Color cl_Checkbox_Item;
  Color cl_save_Btn;
  Color cl_icon_col_save_Btn;
  Color sm_bg_backgroundWO_opacity;
  TextStyle txt_stl_white_white_f22_Heavy;
  TextStyle txt_stl_white_white_f14_Heavy;
  Color cl_appbar_icon_pink;
  Color cl_profile_item_border;
  Color cl_profile_item_bg;
  Color cl_profile_page_bg;
  TextStyle default_swp_left_To_Cont_TextStyle;
  Color sm_bg_background_WOpacity;
  TextStyle txt_stl_error_f12_Light;
  Color cl_darkText_backgroundcolor;

  TextStyle loginpage_hintStyle;
  TextStyle loginpage_FormField_TextStyle;
  TextStyle loginpage_LoginBtn_TextStyle;
  TextStyle loginpage_ForgotYourPassword_TextStyle;
  TextStyle loginpage_SignInWith_TextStyle;
  TextStyle login_error_TextStyle;
  TextStyle txt_stl_whitegrey_13_Book;
  TextStyle txt_stl_whitegrey_14_Med_pltf_grey;
  TextStyle txt_stl_obl_whitegrey_14_Med_pltf_grey;
  TextStyle txt_stl_f14w500_Med_pltf_grey;
  Color cl_grey_op_06;
  Color cl_grey_op_04;
  TextStyle txt_stl_white_pltf_grey_16_Med_700;
}

class ParentSelectedThemeData {
  ParentSelectedThemeData({
    this.selectedThemeData,
    this.isDarkMode,
    this.isFromToggle,
  });
  SelectedThemeData selectedThemeData;
  bool isDarkMode;
  bool isFromToggle;
}

class ParentBuildContext {
  ParentBuildContext({
    this.parentContext,
  });
  BuildContext parentContext;
}

class DatingAppThemeChanger with ChangeNotifier, DiagnosticableTreeMixin {
  SelectedThemeData selectedThemeData;
  bool isDarkThemeSelected;
  void getCurrentTheme(bool isDarkTheme, bool isAtAppInit) {
    String TAG = 'getCurrentTheme:';
    isDarkThemeSelected = isDarkTheme;
    selectedThemeData = DatingAppSelectedTheme.get_themeData(isDarkTheme);
    try {
      if (!isAtAppInit) {
        notifyListeners();
      }
    } catch (error) {
      print(TAG + ' error notifyListeners==');
      print(error.toString());
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty('selectedThemeData', selectedThemeData));
  }
}
