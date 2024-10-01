import 'package:admin_ghuma/const/const.dart';
import 'package:admin_ghuma/views/widgets/text_style.dart';

Widget ourButton({title, color = purpleColor, onPress}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.all(12.0),
    ),
    onPressed: onPress,
    child: normalText(
      text: title,
      size: 18.0,
    ),
  );
}
