import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tandem_typer/src/settings/settings_controller.dart';
import 'package:tandem_typer/src/settings/settings_view.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key, required this.controller});

  static const routeName = '/';

  final SettingsController controller;
  static const String _str =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed viverra sem nulla, a sollicitudin dui ultrices in. Morbi lobortis semper arcu, vel porttitor leo pretium sed. Nullam nisl est, facilisis.';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FocusNode _focusNode = FocusNode();

  final inputFieldController = TextEditingController();

  @override
  void dispose() {
    inputFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        // print(event);
        if (event.logicalKey == LogicalKeyboardKey.space) {
          String word = inputFieldController.text;
          inputFieldController.clear();
          print(word);
        }
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FractionallySizedBox(
              widthFactor: 0.5,
              child: Text(
                HomeView._str,
                style: TextStyle(fontSize: 30),
              ),
            ),
            const Padding(
                padding: EdgeInsetsDirectional.symmetric(vertical: 8)),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: TextField(
                controller: inputFieldController,
                style: const TextStyle(fontSize: 30),
                decoration: InputDecoration(
                  // hintText: 'Type here..',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).hoverColor,
                ),
                inputFormatters: [FilteringTextInputFormatter.deny(' ')],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
