import 'package:flutter/material.dart';

class ObscuredTextField extends StatefulWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final InputDecoration decoration;

  const ObscuredTextField({
    Key? key,
    this.keyboardType = TextInputType.text,
    required this.controller,
    required this.decoration,
  }) : super(key: key);

  @override
  State<ObscuredTextField> createState() => _ObscuredTextFieldState();
}

class _ObscuredTextFieldState extends State<ObscuredTextField> {
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      obscureText: !_passwordVisible,
      decoration: widget.decoration.copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: IconTheme.of(context).color,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
    ;
  }
}
