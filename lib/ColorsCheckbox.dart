class ColorsCheckbox {
  final String colorname;
  bool selected;
  String hexcode; //noch überprüfen ob in richtigem Format: 0xff muss vorne dran sein/angefügt werden und zusätzliche 6 Ziffern für korrekten code, siehe nächste Zeile
/*extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
*/

  ColorsCheckbox({
    required this.colorname,
    this.selected = false,
    required this.hexcode,
  });
}