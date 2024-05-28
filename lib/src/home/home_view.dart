import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tandem_typer/src/settings/settings_controller.dart';
import 'package:tandem_typer/src/settings/settings_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key, required this.controller});

  static const routeName = '/';

  final SettingsController controller;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        print(event);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Home"), actions: [
          IconButton(
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
            icon: const Icon(Icons.settings),
          )
        ]),
        body: const Center(
          child: Text("Hello World!"),
        ),
      ),
    );
  }
}
