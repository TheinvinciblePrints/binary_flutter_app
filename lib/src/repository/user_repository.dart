import 'package:binaryflutterapp/src/api/helper/api_base_helper.dart';
import 'package:binaryflutterapp/src/api/responses/create_user_response.dart';
import 'package:binaryflutterapp/src/api/responses/update_user_response.dart';
import 'package:binaryflutterapp/src/models/data_model.dart';

class UserRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<CreateUserResponse> createUser(Data data) => _helper.post(data);

  Future<UpdateUserResponse> updateUser(Data data) => _helper.put(data);

  Future<Data> deleteUser(String id) => _helper.delete(id);
}
