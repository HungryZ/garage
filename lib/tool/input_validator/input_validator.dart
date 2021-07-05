import 'package:flutter/material.dart';
import 'package:garage/tool/input_validator/input_model.dart';
import 'package:garage/tool/tools.dart';

enum InputValidateType {
  nonnull,
  length,
  maxLength,
  minLength,
  number,
  chinese,
  custom,
}

typedef CustomValidator = bool Function(String content);

class InputValidator {
  InputValidator(
    this.type,
    this.invalidMsg, {
    this.aimValue,
    this.customValidator,
  });

  var aimValue;

  InputValidateType type;

  String invalidMsg;

  CustomValidator? customValidator;

  String? validate(String content) {
    switch (type) {
      case InputValidateType.nonnull:
        if (content.length == 0) return invalidMsg;
        return null;
      case InputValidateType.length:
        double length = aimValue;
        if (content.length != length) return invalidMsg;
        return null;
      case InputValidateType.maxLength:
        double length = aimValue;
        if (content.length > length) return invalidMsg;
        return null;
      case InputValidateType.minLength:
        double length = aimValue;
        if (content.length < length) return invalidMsg;
        return null;
      case InputValidateType.number:
        if (double.tryParse(content) == null) return invalidMsg;
        return null;
      // 未完待补充...
      case InputValidateType.custom:
        if (customValidator != null) {
          if (!customValidator!(content)) return invalidMsg;
        }
        return null;
      default:
        return null;
    }
  }

  static bool check(List<InputModel> list) {
    for (int i = 0; i < list.length; i++) {
      List<InputValidator>? validators = list[i].validators;
      TextEditingController? controller = list[i].controller;
      if (validators == null) return true;
      if (controller == null) return false;
      for (int j = 0; j < validators.length; j++) {
        InputValidator validator = validators[j];
        final message = validator.validate(controller.text);
        if (message != null) {
          toast(message);
          return false;
        }
      }
    }

    return true;
  }
}
