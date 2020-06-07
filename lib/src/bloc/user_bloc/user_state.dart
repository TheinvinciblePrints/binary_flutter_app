import 'package:binaryflutterapp/src/models/users_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserFailure extends UserState {}

class UserSuccess extends UserState {
  final List<Data> data;
  final bool hasReachedMax;

  const UserSuccess({
    this.data,
    this.hasReachedMax,
  });

  UserSuccess copyWith({
    List<Data> data,
    bool hasReachedMax,
  }) {
    return UserSuccess(
      data: data ?? this.data,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [data, hasReachedMax];

  @override
  String toString() =>
      'UserLoaded { users: ${data.length}, hasReachedMax: $hasReachedMax }';
}
