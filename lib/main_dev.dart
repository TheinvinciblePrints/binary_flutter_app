import 'package:binaryflutterapp/main.dart';
import 'package:binaryflutterapp/src/bloc/bloc_delegate.dart';
import 'package:binaryflutterapp/src/config/flavor_config.dart';
import 'package:binaryflutterapp/src/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.DEV, values: FlavorValues(baseUrl: AppConstants.dev_url));

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}
