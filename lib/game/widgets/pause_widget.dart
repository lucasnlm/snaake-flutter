import 'package:flutter/widgets.dart';

import '../../ui/colors.dart';

class PauseWidget extends StatelessWidget {
  PauseWidget({
    this.text,
    this.onTap,
  });

  final GestureTapCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: GameColors.pauseBackground,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
