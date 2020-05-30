import 'package:binaryflutterapp/src/api/helper/api_base_helper.dart';
import 'package:binaryflutterapp/src/api/responses/create_user_response.dart';
import 'package:binaryflutterapp/src/api/responses/delete_user_response.dart';
import 'package:binaryflutterapp/src/api/responses/update_user_response.dart';
import 'package:binaryflutterapp/src/database/dao/contacts_dao.dart';
import 'package:binaryflutterapp/src/models/data_model.dart';

class UserRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  final contactsDao = ContactsDao();

  Future<CreateUserResponse> createUser(Data data) => _helper.post(data);

  Future<UpdateUserResponse> updateUser(String id, Data data) =>
      _helper.put(id, data);

  Future<DeleteUserResponse> deleteUser(String id) => _helper.delete(id);

  Future getContactId(String uuid) => contactsDao.getContactID(uuid);
}
