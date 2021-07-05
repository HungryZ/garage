import 'package:flutter/material.dart';
import 'package:garage/tool/input_validator/input_validator.dart';

class InputModel {
  InputModel({
    this.name,
    this.placeholder,
    this.controller,
    this.keyboardType,
    this.validators,
  });

  String? name;
  String? placeholder;
  TextEditingController? controller;
  TextInputType? keyboardType;
  List<InputValidator>? validators;
}
