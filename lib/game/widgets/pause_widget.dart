import 'package:flutter/widgets.dart';

import '../../ui/colors.dart';

/// Pause widget shown when the game is paused.
class PauseWidget extends StatelessWidget {
  /// Convenient constructor.
  PauseWidget({
    this.text,
    this.onTap,
  });

  /// On tap widget callback.
  final GestureTapCallback onTap;

  /// The text to be shown.
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
