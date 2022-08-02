import 'package:flutter/material.dart';

//0xff65A483
MaterialColor colorAppSwatch = MaterialColor(0xff7D96C0, color);

const colorHeader = Color(0xff2E2C4B);
const colorBorder = Color(0xff2E2C4B);
const colorIcons = Color(0xff2E2C4B);
const colorTheme = Color(0xff2E2C4B);
const colorStatusBar = Color(0xff2E2C4B);

const colorBookmark = Color(0xff2E2C4B);
const colorIconTop = Color(0xff2E2C4B);
const colorAppBar = Color(0xff2E2C4B);
const colorThemeDark = Colors.transparent;
const colorCardLight = Color(0xff2E2C4B);

const cardColorRed = Color(0xffF56C62);
const cardColorYellow = Color(0xffFFD465);
const cardColorLightRed = Colors.white;
const cardColorLightPurple = Color(0xffC5C5D8);
const colorFontCardPurple = Color(0xff3F3D6A);
const colorFontCardRed = Color(0xff80787D);
const colorFontCardBrown = Color(0xffA77F25);
const colorLinearLoad = Color(0xff787491);
const colorCardGrey = Color(0xffDFE6EC);
const colorCardGreyAlt = Color(0xff38393B);
const colorCardGreen = Color(0xff4C6553);
const colorCardGreenAlt = Colors.white;
const colorCardTeal = Color(0xffCDE7D0);
const colorCardTealAlt = Color(0xff038393B);
const colorCardBlue = Colors.white;
const colorCardBlueAlt = Color(0xff38393B);

const colorCardDark = Color(0xffFFBD3D);
const colorfontMain = Color(0xff363251);
const colorfontRed = Colors.red;
const colorSplash = Color(0xffA8D0E6); //splash
const colorProgress = Color(0xffA8D0E6); //progress color
const colorInactive = Colors.grey;
const colorWhite = Colors.white;
const colorGrey = Color(0xffA4A8A6);
const colorDarkGrey = Color.fromRGBO(30, 30, 30, 1);
const colorBlack = Color(0xff000000);
const colorLightGreen = Color(0xffB5EAD7);
const colorLightRed = Color(0xffFFC4C4);
const colorLightPurple = Color(0xffD6D6E0);

Map<int, Color> color = {
  //you will need the rgb code from the colorAppSwatch 115,202,166
  50: Color.fromRGBO(46, 44, 75, .1),
  100: Color.fromRGBO(46, 44, 75, .2),
  200: Color.fromRGBO(46, 44, 75, .3),
  300: Color.fromRGBO(46, 44, 75, .4),
  400: Color.fromRGBO(46, 44, 75, .5),
  500: Color.fromRGBO(46, 44, 75, .6),
  600: Color.fromRGBO(46, 44, 75, .7),
  700: Color.fromRGBO(46, 44, 75, .8),
  800: Color.fromRGBO(46, 44, 75, .9),
  900: Color.fromRGBO(46, 44, 75, 1),
};

// this transforms string to an actual color
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    try {
      if (hexString.substring(0, 4) == "0xff")
        hexString = hexString.replaceRange(0, 4, "#");
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return colorTheme;
    }
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
