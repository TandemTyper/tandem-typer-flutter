import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tandem_typer/src/settings/settings_controller.dart';
import 'package:tandem_typer/src/settings/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.controller});

  static const routeName = '/';

  final SettingsController controller;
  // static const String _str = 'Lorem ipsum dolor sit amet';
  // static const String _str =
  //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed viverra sem nulla, a sollicitudin dui ultrices in. Morbi lobortis semper arcu, vel porttitor leo pretium sed. Nullam nisl est, facilisis.';
  static const String _str =
      'Hello world this is a test string so it should be much easier to type than the lorem ipsum.';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FocusNode _kbListenerFocusNode = FocusNode();
  final _inputFieldController = TextEditingController();

  int _numCorrectWordsTyped = 0;
  Iterator<String> _iter = HomeView._str.split(' ').iterator;
  bool _typing = false;
  bool _finished = false;
  int _startTime = 0;
  double _wpm = 0;
  Timer? _wpmCalculator;

  void start() {
    _finished = false;
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _wpmCalculator =
        Timer.periodic(const Duration(milliseconds: 750), (Timer t) {
      _wpm = _numCorrectWordsTyped /
          (DateTime.now().millisecondsSinceEpoch - _startTime) *
          1000 *
          60;
      print('timer');
      setState(() {});
    });
    setState(() {});
  }

  void reset() {
    _inputFieldController.clear();
    _iter = HomeView._str.split(' ').iterator;
    _iter.moveNext();
    _numCorrectWordsTyped = 0;
    _typing = false;
    _wpmCalculator?.cancel();
    setState(() {});
  }

  void onSpacePressed(KeyEvent event) {
    String word = _inputFieldController.text;
    if (word.isEmpty) return;
    _inputFieldController.clear();
    if (word == _iter.current) {
      _numCorrectWordsTyped++;
    }
    if (!_iter.moveNext()) {
      reset();
      setState(() {
        _finished = true;
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    _iter.moveNext();
    super.initState();
  }

  @override
  void dispose() {
    _inputFieldController.dispose();
    _wpmCalculator?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _kbListenerFocusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.space &&
            event is KeyDownEvent) {
          onSpacePressed(event);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(padding: EdgeInsetsDirectional.only(bottom: 25)),
              Visibility(
                visible: _typing || _finished,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$_numCorrectWordsTyped',
                        style: const TextStyle(fontSize: 40)),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20)),
                    Text('${_wpm.round()}',
                        style: const TextStyle(fontSize: 30)),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsetsDirectional.only(bottom: 25)),
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
                  onChanged: (value) {
                    if (!_typing) {
                      setState(() {
                        _typing = true;
                      });
                      start();
                    }
                  },
                  controller: _inputFieldController,
                  style: const TextStyle(fontSize: 30),
                  decoration: InputDecoration(
                    hintText: _iter.current,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).hoverColor,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                ),
              ),
              const Padding(padding: EdgeInsetsDirectional.only(bottom: 50)),
              TextButton(
                onPressed: () => reset(),
                child: const Icon(
                  Icons.refresh,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
