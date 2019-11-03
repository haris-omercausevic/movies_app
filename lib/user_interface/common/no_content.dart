import 'package:flutter/material.dart';

import 'package:movies_app/utilities/localization/localizer.dart';

class NoContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Localizer _localizer = Localizer.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text(_localizer.translation.noContent)),
    );
  }
}
