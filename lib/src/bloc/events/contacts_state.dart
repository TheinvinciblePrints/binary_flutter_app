import 'package:binaryflutterapp/src/models/contacts.dart';
import 'package:equatable/equatable.dart';

abstract class ContactStates extends Equatable {
  ContactStates([List props = const []]) : super(props);
}

class LoadingContactState extends ContactStates {}

class EmptyContactState extends ContactStates {}

class LoadedContactState extends ContactStates {
  List<Contacts> list;

  LoadedContactState(this.list) : super([list]);
}
