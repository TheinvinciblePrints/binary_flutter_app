import 'package:binaryflutterapp/src/api/responses/update_user_response.dart';
import 'package:binaryflutterapp/src/models/users_model.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditUserBloc extends Bloc<UpdateEvent, UpdateState> {
  final UserRepository _userRepository;

  EditUserBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  UpdateState get initialState => InitialState();

  @override
  Stream<UpdateState> mapEventToState(
    UpdateEvent event,
  ) async* {
    if (event is SubmitInput) {
      yield SubmitState();
      try {
        UpdateUserResponse status =
            await _userRepository.updateUser(event.uuid, event.data);

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

abstract class UpdateEvent extends Equatable {
  const UpdateEvent();

  @override
  List<Object> get props => [];
}

class SubmitInput extends UpdateEvent {
  final Data data;
  final String uuid;

  const SubmitInput({@required this.data, @required this.uuid});

  @override
  List<Object> get props => [data];
}

abstract class UpdateState extends Equatable {
  const UpdateState();

  @override
  List<Object> get props => [];
}

class InitialState extends UpdateState {}

class SubmitState extends UpdateState {}

class SuccessState extends UpdateState {
  final Data data;

  SuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class FailureState extends UpdateState {
  final String message;

  FailureState(this.message);

  @override
  List<Object> get props => [message];
}
