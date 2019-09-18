import 'package:flutter/material.dart';

class ApiResponse<T> {
  int statusCode;
  bool hasError;
  T content;

  ApiResponse({this.hasError = false, this.content, this.statusCode});
}
