import 'dart:async';

import 'package:binaryflutterapp/src/bloc/user_bloc/user_event.dart';
import 'package:binaryflutterapp/src/bloc/user_bloc/user_state.dart';
import 'package:binaryflutterapp/src/models/contacts_model.dart';
import 'package:binaryflutterapp/src/models/users_model.dart';
import 'package:binaryflutterapp/src/repository/contacts_repository.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final _contactsRepository = ContactsRepository();

  UserBloc({@required this.userRepository});

  int pageNumber = 1;
  int rowNumber = 50;

  @override
  Stream<UserState> transformEvents(
      Stream<UserEvent> events, Stream<UserState> Function(UserEvent p1) next) {
    return super.transformEvents(
        events.debounceTime(const Duration(milliseconds: 500)), next);
  }

  @override
  get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    final currentState = state;
    if (event is UsersFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is UserInitial) {
          final response =
              await userRepository.fetchUserList(pageNumber, rowNumber);

          for (int index = 0; index < response.data.length; index++) {
            Data _data = response.data[index];
            Contacts contacts = Contacts(
              UUID: _data.id,
              first_name: _data.firstName,
              last_name: _data.lastName,
              gender: _data.gender,
              dob: _data.dateOfBirth,
              mobile: _data.phoneNo,
              email: _data.email,
              title: '',
              company: '',
              operation: 0,
              isFavourite: false,
            );

            await _contactsRepository.insertContact(contacts);
          }

          List<Data> dataResponse = response.data;

          dataResponse.sort((a, b) {
            return a.firstName
                .toLowerCase()
                .compareTo(b.firstName.toLowerCase());
          });

          yield UserSuccess(data: dataResponse, hasReachedMax: false);
          return;
        }
        if (currentState is UserSuccess) {
          pageNumber++;
          final response =
              await userRepository.fetchUserList(pageNumber, rowNumber);

          if (response.data.isNotEmpty) {
            for (int index = 0; index < response.data.length; index++) {
              Data _data = response.data[index];
              Contacts contacts = Contacts(
                UUID: _data.id,
                first_name: _data.firstName,
                last_name: _data.lastName,
                gender: _data.gender,
                dob: _data.dateOfBirth,
                mobile: _data.phoneNo,
                email: _data.email,
                title: '',
                company: '',
                operation: 0,
                isFavourite: false,
              );

              await _contactsRepository.insertContact(contacts);
            }
          }

          List<Data> loadedData = currentState.data + response.data;

          loadedData.sort((a, b) {
            return a.firstName
                .toLowerCase()
                .compareTo(b.firstName.toLowerCase());
          });

          yield response.data.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : UserSuccess(
                  data: loadedData,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield UserFailure();
      }
    }
  }

  bool _hasReachedMax(UserState state) =>
      state is UserSuccess && state.hasReachedMax;
}
