import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final bool obsecure;
  Mytextfield(
      {required this.controller,
      required this.hinttext,
      required this.obsecure});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecure,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.white70,
        hintStyle: TextStyle(fontSize: 16, color: Colors.black),
        hintText: hinttext,
      ),
    );
  }
}
