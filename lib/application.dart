import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:movies_app/config/all.dart';
import 'package:movies_app/user_interface/pages/all.dart';
import 'package:movies_app/user_interface/common/all.dart';
import 'package:movies_app/user_interface/pages/movies_page.dart';
import 'package:movies_app/utilities/localization/localizer.dart';

import 'blocs/movies/all.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        primarySwatch: Colors.red,
        backgroundColor: Color(0xFF2D2C2C),
        fontFamily: AppSettings.fontFamily,
        scaffoldBackgroundColor: Colors.white,
      ),
      localizationsDelegates: [
        Localizer.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      builder: (BuildContext context, Widget child) {
        return AppTheme(
          appTheme: AppThemeData(
            inputBorderColor: Colors.black,
            inputBorderColorDark: Colors.white,
            facebookBackgroundColor: Colors.blueAccent,
            googleBackgroundColor: Colors.red,
            primaryTextColor: Colors.white,
          ),
          child: child,
        );
      },
      home: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          //TODO: Remove for app with authentication
          //return HomePage();

          if (state is Loading) {
            return Loader();
          }

          return MoviesPage();
        },
      ),
      title: AppSettings.name,
      onGenerateRoute: this._onGenerateRoute,
      localeResolutionCallback: Localizer.getSupportedLocale,
    );
  }

  PageRoute _onGenerateRoute(RouteSettings settings) {
    print(settings.arguments.toString());

    switch (settings.name) {
      case HomePage.routeName:
        return MaterialPageRoute(builder: (_) => HomePage(), settings: settings);
      case RegisterPage.routeName:
        return MaterialPageRoute(builder: (_) => RegisterPage(), settings: settings);
    }

    return null;
  }
}
