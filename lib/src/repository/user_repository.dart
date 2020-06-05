import 'package:binaryflutterapp/src/api/helper/api_base_helper.dart';
import 'package:binaryflutterapp/src/api/responses/create_user_response.dart';
import 'package:binaryflutterapp/src/api/responses/delete_user_response.dart';
import 'package:binaryflutterapp/src/api/responses/update_user_response.dart';
import 'package:binaryflutterapp/src/api/responses/user_response.dart';
import 'package:binaryflutterapp/src/models/users_model.dart';

class UserRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserResponse> fetchUserList(int pageNumber, int rowNumber) async {
    final response = await _helper.getUserList(pageNumber, rowNumber);
    return response;
  }

  Future<CreateUserResponse> createUser(Data data) => _helper.addUser(data);

  Future<UpdateUserResponse> updateUser(String uuid, Data data) =>
      _helper.updateUser(uuid, data);

  Future<DeleteUserResponse> deleteUser(String uuid) =>
      _helper.deleteUser(uuid);
}
