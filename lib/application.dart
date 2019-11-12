import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:movies_app/config/all.dart';
import 'package:movies_app/user_interface/pages/all.dart';
import 'package:movies_app/user_interface/common/all.dart';
import 'package:movies_app/user_interface/pages/movies_details_page.dart';
import 'package:movies_app/user_interface/pages/movies_page.dart';
import 'package:movies_app/user_interface/pages/users_page.dart';
import 'package:movies_app/utilities/localization/localizer.dart';



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
        primarySwatch: Colors.blue,
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
      home: HomePage(),     
      title: AppSettings.name,
      onGenerateRoute: this._onGenerateRoute,
      localeResolutionCallback: Localizer.getSupportedLocale,      
    );
  }

  PageRoute _onGenerateRoute(RouteSettings settings) {    
    switch (settings.name) {
      case HomePage.routeName:
        return MaterialPageRoute(builder: (_) => HomePage(), settings: settings);
      case MoviesPage.routeName:
        return MaterialPageRoute(builder: (_) => MoviesPage(moviesBloc: settings.arguments), settings: settings);
      case MoviesDetailsPage.routeName:
        return MaterialPageRoute(builder: (_) => MoviesDetailsPage(movieItem: settings.arguments), settings: settings);
      case UsersDetailsPage.routeName:
        return MaterialPageRoute(builder: (_) => UsersDetailsPage(usersBloc:settings.arguments), settings: settings);
    }

    return null;
  }
}
