import 'package:flutter/material.dart';

// 支持的类型
enum InputType {
  string,
  number,
  password,
  piCode,
  button,
}

class FormData {
  FormData({
    this.id = '',
    this.icon = Icons.person_outline,
    this.key = '',
    this.type = InputType.string,
    this.hintText,
    this.helperText,
    this.errorText,
    this.buttonText,
  });

  String id;
  IconData icon;
  String key;
  InputType type;
  String? hintText;
  String? helperText;
  String? errorText;
  String? buttonText;

  static List<FormData> loginForm = [
    FormData(
      id: '1',
      type: InputType.string,
      icon: Icons.person_outline,
      key: 'userName',
      hintText: '请输入用户名',
    ),
    FormData(
      id: '2',
      type: InputType.password,
      icon: Icons.lock_outline_rounded,
      key: 'password',
      hintText: '请输入密码',
    ),
    FormData(
      id: '4',
      type: InputType.piCode,
      icon: Icons.image,
      key: 'imageCode',
      hintText: '请输入验证码',
    ),
    FormData(
      id: '3',
      type: InputType.button,
      key: 'submit',
      buttonText: '登录',
    ),
  ];

  static List<FormData> registerForm = [

  ];
}