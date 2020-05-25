import 'package:binaryflutterapp/src/models/contacts.dart';
import 'package:equatable/equatable.dart';

//base class for events
abstract class ContactEvents extends Equatable {
  ContactEvents([List props = const []]) : super(props);
}

class AddContactEvent extends ContactEvents {
  final Contacts contact;

  AddContactEvent(this.contact) : super([contact]);
}

class DeleteContactEvent extends ContactEvents {
  final Contacts contact;

  DeleteContactEvent(this.contact) : super([contact]);
}

class UpdateContactEvent extends ContactEvents {
  final Contacts contact;

  UpdateContactEvent(this.contact) : super([contact]);
}

class QueryContactEvent extends ContactEvents {}
