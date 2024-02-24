import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulms/main.dart';

class ThemeHelper extends ChangeNotifier {
  final _key = "isDarktheme";
  final Color _primaryColor = Colors.blue;
  final Color _accentColor = Colors.blueAccent;
  _saveThemeToSp(String? isDarkTheme) {
    saveLocal.write(key: _key, value: isDarkTheme);
  }

  // ignore: unrelated_type_equality_checks
  _loadThemeSp() {
    // var ans = '';
    return saveLocal.read(key: _key);
  }

  ThemeMode get theme =>
      _loadThemeSp() == 'true' ? ThemeMode.light : ThemeMode.dark;
  void swithThemeMode() {
    print(_loadThemeSp());
    _loadThemeSp() == 'true' ? ThemeMode.dark : ThemeMode.light;
    _saveThemeToSp(_loadThemeSp() == 'true' ? "false" : "true");
  }

  InputDecoration textInputDecoration(
      [String lableText = "", String hintText = ""]) {
    return InputDecoration(
      hintStyle: const TextStyle(color: Colors.blue),
      labelStyle: const TextStyle(color: Colors.blue),
      labelText: lableText,
      hintText: hintText,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.blue)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.blueAccent)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  BoxDecoration inputBoxDecorationShaddow() {
    return const BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.white,
        blurRadius: 20,
        offset: Offset(0, 5),
      )
    ]);
  }

  BoxDecoration buttonBoxDecoration(BuildContext context,
      [String color1 = "", String color2 = ""]) {
    Color c1 = _primaryColor;
    Color c2 = _accentColor;
    if (color1.isEmpty == false) {
      c1 = HexColor(color1);
    }
    if (color2.isEmpty == false) {
      c2 = HexColor(color2);
    }

    return BoxDecoration(
      boxShadow: const [
        BoxShadow(color: Colors.blue, offset: Offset(0, 4), blurRadius: 5.0)
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 1.0],
        colors: [
          c1,
          c2,
        ],
      ),
      color: Colors.blue.shade300,
      borderRadius: BorderRadius.circular(30),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      minimumSize: MaterialStateProperty.all(const Size(30, 30)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
    );
  }

  Center progressBar() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  Center progressBar2() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    );
  }

  fluent.NavigationAppBar appbar() {
    return fluent.NavigationAppBar(
        title: const Text(
          'UniApp',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: Row(children: [
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: CircleAvatar(),
          ),
          const SizedBox(
            width: 50,
          ),
          GestureDetector(
            onTap: (() {
              ThemeHelper().swithThemeMode();
            }),
            child: const Icon(
              Icons.nightlight_round,
              size: 20,
            ),
          ),
        ]));
  }

  // fluent.NavigationPane navPane1(index) {
  //   return fluent.NavigationPane(
  //       selected: index,
  //       onChanged: ((value) {
  //         index = value;
  //       }),
  //       items: [
  //         fluent.PaneItem(
  //             icon: const Icon(
  //               fluent.FluentIcons.dashboard_add,
  //             ),
  //             title: const Text(
  //               "Dashboard",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             )),
  //         fluent.PaneItem(
  //             icon: const Icon(
  //               fluent.FluentIcons.book_answers,
  //             ),
  //             title: const Text("Department Courses",
  //                 style: TextStyle(fontWeight: FontWeight.bold))),
  //         fluent.PaneItem(
  //             icon: const Icon(
  //               fluent.FluentIcons.book_answers,
  //             ),
  //             title: const Text("My Courses",
  //                 style: TextStyle(fontWeight: FontWeight.bold))),
  //         fluent.PaneItem(
  //             icon: const Icon(
  //               fluent.FluentIcons.test_add,
  //             ),
  //             title: const Text("Test",
  //                 style: TextStyle(fontWeight: FontWeight.bold))),
  //         fluent.PaneItem(
  //             icon: const Icon(
  //               fluent.FluentIcons.account_management,
  //             ),
  //             title: const Text("My Profile",
  //                 style: TextStyle(fontWeight: FontWeight.bold))),
  //         fluent.PaneItem(
  //             icon: const Icon(
  //               fluent.FluentIcons.alert_solid,
  //             ),
  //             title: const Text("Notification",
  //                 style: TextStyle(fontWeight: FontWeight.bold)))
  //       ]);
  // }

  AlertDialog alartDialog(String title, String content, BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black38)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child:const Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class HeaderWidget extends StatefulWidget {
  final double _height;
  final bool _showIcon;
  final IconData _icon;

  const HeaderWidget(this._height, this._showIcon, this._icon, {Key? key})
      : super(key: key);

  @override
  _HeaderWidgetState createState() =>
      _HeaderWidgetState(_height, _showIcon, _icon);
}

class _HeaderWidgetState extends State<HeaderWidget> {
  double _height;
  bool _showIcon;
  IconData _icon;

  _HeaderWidgetState(this._height, this._showIcon, this._icon);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Stack(
        children: [
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [Colors.blue.withOpacity(0.4), Colors.white],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 10 * 5, _height - 60),
              Offset(width / 5 * 4, _height + 20),
              Offset(width, _height - 18)
            ]),
          ),
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Colors.purple.withOpacity(0.4),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 3, _height + 20),
              Offset(width / 10 * 8, _height - 60),
              Offset(width / 5 * 4, _height - 60),
              Offset(width, _height - 20)
            ]),
          ),
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 2, _height - 40),
              Offset(width / 5 * 4, _height - 80),
              Offset(width, _height - 20)
            ]),
          ),
          Visibility(
            visible: _showIcon,
            child: Container(
              height: _height - 40,
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.only(
                    left: 5.0,
                    top: 20.0,
                    right: 5.0,
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                    border: Border.all(width: 5, color: Colors.white),
                  ),
                  child: widget._icon != Icons.person_add_alt_1_rounded
                      ? Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 5, color: Colors.white),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20,
                                offset: const Offset(5, 5),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "images/uniappLogo.png",
                            height: 80,
                            width: 80,
                          ))
                      : Icon(
                          _icon,
                          color: Colors.white,
                          size: 40.0,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];
  ShapeClipper(this._offsets);
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height - 20);

    // path.quadraticBezierTo(size.width/5, size.height, size.width/2, size.height-40);
    // path.quadraticBezierTo(size.width/5*4, size.height-80, size.width, size.height-20);

    path.quadraticBezierTo(
        _offsets[0].dx, _offsets[0].dy, _offsets[1].dx, _offsets[1].dy);
    path.quadraticBezierTo(
        _offsets[2].dx, _offsets[2].dy, _offsets[3].dx, _offsets[3].dy);

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
