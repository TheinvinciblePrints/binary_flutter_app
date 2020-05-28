import 'package:binaryflutterapp/src/api/responses/create_user_response.dart';
import 'package:binaryflutterapp/src/models/data_model.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  final UserRepository _userRepository;

  CreateBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  CreateState get initialState => InitialState();

  @override
  Stream<CreateState> mapEventToState(
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

abstract class CreateState extends Equatable {
  const CreateState();

  @override
  List<Object> get props => [];
}

class InitialState extends CreateState {}

class SubmitState extends CreateState {}

class SuccessState extends CreateState {
  final Data data;

  SuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class FailureState extends CreateState {
  final String message;

  FailureState(this.message);

  @override
  List<Object> get props => [message];
}
