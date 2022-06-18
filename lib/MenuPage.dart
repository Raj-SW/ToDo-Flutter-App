// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:devstack/menuItem.dart';
import 'package:flutter/material.dart';

class MenuItems {
  static const homePage = MenuItema('HomePage', Icons.format_list_numbered_rtl);
  static const Settings = MenuItema('Settings', Icons.settings);

  static const all = <MenuItema>[homePage, Settings];
}

class MenuPage extends StatefulWidget {
  final MenuItema currentItem;
  final ValueChanged<MenuItema> onSelectedItem;
  const MenuPage({
    Key? key,
    required this.currentItem,
    required this.onSelectedItem,
  }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          CircleAvatar(
            foregroundImage: AssetImage("assets/pepe.jpg"),
            radius: 40,
          ),
          SizedBox(
            height: 50,
          ),
          ...MenuItems.all.map(buildMenuItem).toList(),
          Spacer(),
          Spacer(),
          Spacer(),
          Spacer(),
        ],
      )),
    );
  }

  Widget buildMenuItem(MenuItema item) => SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTileTheme(
              selectedColor: Colors.deepPurple,
              textColor: Colors.white,
              child: ListTile(
                minLeadingWidth: 20,
                selected: widget.currentItem == item,
                selectedTileColor: Colors.white70,

                //leading: Icon(item.icon),
                title: Text(item.title),
                onTap: () => widget.onSelectedItem(item),
              ),
            ),
          ],
        ),
      );
}
