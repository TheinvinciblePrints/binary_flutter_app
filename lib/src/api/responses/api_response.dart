import 'package:binaryflutterapp/src/api/responses/user_response.dart';
import 'package:binaryflutterapp/src/enums/api_response_enum.dart';

class ApiResponse<T> {
  Status status;

  UserResponse users;

  String message;

  ApiResponse.loading() : status = Status.LOADING;

  ApiResponse.completed(this.users) : status = Status.COMPLETED;

  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $users";
  }
}
