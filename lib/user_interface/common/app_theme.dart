import 'package:flutter/material.dart';

@immutable
class AppThemeData {
  final Color inputBorderColor;
  final Color inputBorderColorDark;
  final Color facebookBackgroundColor;
  final Color googleBackgroundColor;
  final Color primaryTextColor;

  final customPrimarySwatch = MaterialColor(0xFFD71F66, {
    50: Color(0xFFFAE4ED),
    100: Color(0xFFF3BCD1),
    200: Color(0xFFEB8FB3),
    300: Color(0xFFE36294),
    400: Color(0xFFDD417D),
    500: Color(0xFFD71F66),
    600: Color(0xFFD31B5E),
    700: Color(0xFFCD1753),
    800: Color(0xFFC71249),
    900: Color(0xFFBE0A38),
  });

  AppThemeData({
    @required this.inputBorderColor,
    @required this.inputBorderColorDark,
    @required this.facebookBackgroundColor,
    @required this.googleBackgroundColor,
    @required this.primaryTextColor,
  })  : assert(inputBorderColor != null),
        assert(inputBorderColorDark != null),
        assert(facebookBackgroundColor != null),
        assert(googleBackgroundColor != null),
        assert(primaryTextColor != null);
}

class AppTheme extends StatelessWidget {
  final Widget child;
  final AppThemeData appTheme;

  const AppTheme({
    Key key,
    @required this.child,
    @required this.appTheme,
  })  : assert(child != null),
        assert(appTheme != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _InheritedAppTheme(
      child: this.child,
      appThemeData: appTheme,
    );
  }

  static AppThemeData of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedAppTheme) as _InheritedAppTheme).appThemeData;
  }
}

class _InheritedAppTheme extends InheritedWidget {
  final AppThemeData appThemeData;

  const _InheritedAppTheme({
    Key key,
    @required Widget child,
    @required this.appThemeData,
  })  : assert(appThemeData != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedAppTheme old) => appThemeData != old.appThemeData;
}
