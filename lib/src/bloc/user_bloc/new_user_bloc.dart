import 'package:binaryflutterapp/src/api/responses/user_response.dart';
import 'package:binaryflutterapp/src/models/users_model.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class CountryBloc {
  final _repository = UserRepository();

  final _countriesFetcher = PublishSubject<List<Data>>();

  Stream<List<Data>> get allContacts => _countriesFetcher.stream;

  int firstIndex = 0;

  List<Data> initialList = [];

  int listLength;

  int pageNumber = 1;
  int rowNumber = 50;

  fetchUsers() async {
    UserResponse itemModel =
        await _repository.fetchUserList(pageNumber, rowNumber);
    listLength = itemModel.data.length;
    initialList = itemModel.data.sublist(0, listLength);
    _countriesFetcher.sink.add(initialList);
    firstIndex = itemModel.data.sublist(firstIndex, listLength).length;
  }

  fetchMoreCountries() async {
    print('LoadMore: called');
//    pageNumber++;
//    UserResponse itemModel =
//        await _repository.fetchUserList(pageNumber, rowNumber);
//
//    int lastIndex = itemModel.data.sublist(0, rowNumber).length;
//    await Future.delayed(Duration(seconds: 2));
//    if (lastIndex <= itemModel.data.length) {
//      initialList = initialList + itemModel.data.sublist(firstIndex, lastIndex);
//      _countriesFetcher.sink.add(initialList);
//      firstIndex = lastIndex;
//    }
  }

  dispose() {
    _countriesFetcher.close();
  }
}

final bloc = CountryBloc();
