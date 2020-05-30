import 'package:binaryflutterapp/src/api/responses/delete_user_response.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteUserBloc extends Bloc<DeleteEvent, DeleteState> {
  final UserRepository _userRepository;

  DeleteUserBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  DeleteState get initialState => DeleteInitialState();

  @override
  Stream<DeleteState> mapEventToState(
    DeleteEvent event,
  ) async* {
    if (event is DeleteSubmitInput) {
      yield DeleteSubmitState();
      try {
        DeleteUserResponse status =
            await _userRepository.deleteUser(event.uuid);

        print('deleteStatus: ${status.data}');

        if (status.data != null) {
//          var contact_id = await _userRepository.getContactId(status.data);

          print('deleteContactId: ${status.data}');

          yield DeleteSuccessState(status.data);
        } else {
          yield DeleteFailureState('Failed to save data');
        }

        // yield isSuccess();
      } catch (e) {
        print("Error coy");
        yield DeleteFailureState(e.toString());
      }
    }
  }
}

abstract class DeleteEvent extends Equatable {
  const DeleteEvent();

  @override
  List<Object> get props => [];
}

class DeleteSubmitInput extends DeleteEvent {
  final String uuid;

  const DeleteSubmitInput({@required this.uuid});

  @override
  List<Object> get props => [uuid];
}

abstract class DeleteState extends Equatable {
  const DeleteState();

  @override
  List<Object> get props => [];
}

class DeleteInitialState extends DeleteState {}

class DeleteSubmitState extends DeleteState {}

class DeleteSuccessState extends DeleteState {
  final String UUID;

  DeleteSuccessState(this.UUID);

  @override
  List<Object> get props => [UUID];
}

class DeleteFailureState extends DeleteState {
  final String message;

  DeleteFailureState(this.message);

  @override
  List<Object> get props => [message];
}
