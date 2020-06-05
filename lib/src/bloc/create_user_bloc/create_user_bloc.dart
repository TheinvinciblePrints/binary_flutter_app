import 'package:binaryflutterapp/src/api/responses/create_user_response.dart';
import 'package:binaryflutterapp/src/models/users_model.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUserBloc extends Bloc<CreateEvent, CreateUserState> {
  final UserRepository _userRepository;

  CreateUserBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  CreateUserState get initialState => InitialState();

  @override
  Stream<CreateUserState> mapEventToState(
    CreateEvent event,
  ) async* {
    if (event is SubmitInput) {
      yield SubmitState();
      try {
        CreateUserResponse status =
            await _userRepository.createUser(event.data);

        if (status != null) {
          yield SuccessState(status.data);
        } else {
          yield FailureState('Failed to save data');
        }

        // yield isSuccess();
      } catch (e) {
        print("Error coy");
        yield FailureState(e.toString());
      }
    }
  }
}

abstract class CreateEvent extends Equatable {
  const CreateEvent();

  @override
  List<Object> get props => [];
}

class SubmitInput extends CreateEvent {
  final Data data;

  const SubmitInput({
    @required this.data,
  });

  @override
  List<Object> get props => [data];
}

abstract class CreateUserState extends Equatable {
  const CreateUserState();

  @override
  List<Object> get props => [];
}

class InitialState extends CreateUserState {}

class SubmitState extends CreateUserState {}

class SuccessState extends CreateUserState {
  final Data data;

  SuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class FailureState extends CreateUserState {
  final String message;

  FailureState(this.message);

  @override
  List<Object> get props => [message];
}
