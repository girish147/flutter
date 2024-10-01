import 'package:admin_ghuma/const/const.dart';

Widget loadingIndicator({circleColor = purpleColor}) {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(circleColor),
  );
}
