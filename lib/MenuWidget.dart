// ignore_for_file: file_names

import 'package:devstack/Service/SoundSystem.dart';
import 'package:flutter/material.dart';

import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () {
          SoundSystem().playLocal();
          ZoomDrawer.of(context)!.toggle();
        },
        icon: const Icon(Icons.menu),
      );
}
