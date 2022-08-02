import 'package:radoncinservice/constants/color_constant.dart';
import 'package:radoncinservice/setup/init_landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class InitApp extends StatelessWidget {
  const InitApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'AuthApp',
      theme: ThemeData(
        //Main
        textTheme: TextTheme(
          headline1: GoogleFonts.roboto(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: colorfontMain,
              letterSpacing: -1),

          //List Labels
          headline2: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
            color: colorfontMain,
          ),
          //cardSubtitle

          headline3: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            letterSpacing: -1,
            color: colorfontMain,
          ),

          //// body

          headline4: TextStyle(
            // child on lists
            fontFamily: 'OpenSans',
            fontSize: 16.0,
            color: colorfontMain,
            fontWeight: FontWeight.normal,
          ),

          headline5: TextStyle(
            // underline child on lists
            fontFamily: 'OpenSans',
            fontSize: 13.0,
            color: colorfontMain,
            fontWeight: FontWeight.normal,
          ),

          headline6: TextStyle(
            //search bar
            fontFamily: 'OpenSans',
            fontSize: 16.0,
            color: Colors.black87,
            fontWeight: FontWeight.normal,
          ),

          bodyText1: TextStyle(
            // main text font
            fontFamily: 'OpenSans',
            fontSize: 15,
            //fontSize: 13.0,
            color: colorfontMain,
            fontWeight: FontWeight.normal,
          ),

          bodyText2: TextStyle(
            //highlight body font
            color: colorfontMain, fontFamily: 'OpenSans', fontSize: 13,
            fontWeight: FontWeight.normal,
          ),

          subtitle1: TextStyle(
            //Screen Titles Small //this is also the loging text color
            fontFamily: 'OpenSans',
            fontSize: 15.0,
            color: colorTheme,
            fontWeight: FontWeight.normal,
          ),

          subtitle2: TextStyle(
            //top text 2
            fontFamily: 'OpenSans',
            fontSize: 12.0,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),

          caption: TextStyle(
            //note text black
            color: Colors.black87, fontFamily: 'OpenSans', fontSize: 12,
          ),

          overline: TextStyle(
            //LIST CITATION
            color: Colors.black38,
            fontFamily: 'OpenSans',
            fontSize: 10,
            letterSpacing: 0,
          ),

          button: TextStyle(
            //LIST TRIAL TEXT LIST
            color: colorfontMain,
            fontFamily: 'OpenSans',
            fontSize: 14,
            letterSpacing: 0,
          ),
          //how to input Theme.of(context).textTheme.headline5  or  theme.textTheme.bodyText1
        ),
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
//          systemOverlayStyle: SystemUiOverlayStyle(
//            statusBarColor: Colors.indigo[800],
//            // Android - colors of icons
//            statusBarIconBrightness: Brightness.light,
//            // iOS - brightness of status bar (for indigo color - dark)
//            statusBarBrightness: Brightness.dark,
//          ),
        ),
        primarySwatch: colorAppSwatch,
        accentColor: colorTheme,
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          },
        ),
      ),

      //home: GetLandingPage(key: Key("Get Landing Page")),
      initialRoute: "/",
      routes: {
        "/": (context) => GetLandingPage(key: Key("Get Landing Page")),
      },
    );
  }
}

Map<int, Color> getSwatch(Color color) {
  final hslColor = HSLColor.fromColor(color);
  final lightness = hslColor.lightness;

  /// if [500] is the default color, there are at LEAST five
  /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
  /// divisor of 5 would mean [50] is a lightness of 1.0 or
  /// a color of #ffffff. A value of six would be near white
  /// but not quite.
  final lowDivisor = 6;

  /// if [500] is the default color, there are at LEAST four
  /// steps above [500]. A divisor of 4 would mean [900] is
  /// a lightness of 0.0 or color of #000000
  final highDivisor = 5;

  final lowStep = (1.0 - lightness) / lowDivisor;
  final highStep = lightness / highDivisor;

  return {
    50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
    100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
    200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
    300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
    400: (hslColor.withLightness(lightness + lowStep)).toColor(),
    500: (hslColor.withLightness(lightness)).toColor(),
    600: (hslColor.withLightness(lightness - highStep)).toColor(),
    700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
    800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
    900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
  };
}

MaterialColor createMaterialColor(Color color) {
  return MaterialColor(
    color.value,
    getSwatch(color),
  );
}
