import 'package:binaryflutterapp/src/api/services/user_api_service.dart';
import 'package:binaryflutterapp/src/models/users.dart';

class UserRepository {
  final apiService = ApiService();

  Future<Data> createUser(Data data) => apiService.createUser(data);
}
