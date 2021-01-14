import 'package:flutter/material.dart';
import 'package:munchkin/logic/cubit/game_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPlayerInput extends StatefulWidget {
  @override
  _NewPlayerInputState createState() => _NewPlayerInputState();
}

class _NewPlayerInputState extends State<NewPlayerInput> {
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: _controller,
      decoration: InputDecoration(hintText: 'Enter a new player'),
      onSubmitted: (name) {
        _controller.clear();
        context.read<GameCubit>().addPlayer(name);
        _focusNode.requestFocus();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
