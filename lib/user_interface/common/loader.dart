import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';

import 'package:movies_app/config/all.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Container(
      child: Center(
        child: SizedBox(
          child: FlareActor(
            Assets.loader,
            animation: "play",
          ),
          height: 64,
        ),
      ),
      color: _theme.backgroundColor,
    );
  }
}
