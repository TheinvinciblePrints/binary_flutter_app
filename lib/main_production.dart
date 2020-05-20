import 'package:binaryflutterapp/main.dart';
import 'package:binaryflutterapp/src/config/flavor_config.dart';
import 'package:binaryflutterapp/src/constants/app_constants.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.PRODUCTION,
      values: FlavorValues(baseUrl: AppConstants.production_url));

  runApp(MyApp());
}