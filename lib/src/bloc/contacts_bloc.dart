import 'dart:async';

import 'package:binaryflutterapp/src/bloc/events/contact_events.dart';
import 'package:binaryflutterapp/src/bloc/events/contacts_state.dart';
import 'package:binaryflutterapp/src/repository/contacts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsBloc extends Bloc<ContactEvents, ContactStates> {
  final ContactsRepository _contactsRepository;
  int tdlCount = 0;
  int isDoneCount = 0;

  ContactsBloc(this._contactsRepository);

  @override
  ContactStates get initialState => LoadingContactState();

  @override
  Stream<ContactStates> mapEventToState(ContactEvents event) async* {
    // Add contacts event
    if (event is AddContactEvent) {
      //insert _contact to db
      await _contactsRepository.insertContact(event.contact);

      //query db to update ui
      add(QueryContactEvent());
//
    } else if (event is UpdateContactEvent) {
      //update _todo
      await _contactsRepository.updateContact(event.contact);

      //query db to update ui
      add(QueryContactEvent());
    } else if (event is DeleteContactEvent) {
      //delete _todo
      await _contactsRepository.deleteContactById(event.contact.id);

      //query db to update ui
      add(QueryContactEvent());
    } else if (event is QueryContactEvent) {
      print("query");
      //get all items
      final tdl = await _contactsRepository.getAllContacts();

      if (tdl.isEmpty) {
        //yield empty state if list is empty
        yield EmptyContactState();
      } else {
        //yield loaded state unto the stream with the list
        yield LoadedContactState(tdl);
      }
    }
  }
}
