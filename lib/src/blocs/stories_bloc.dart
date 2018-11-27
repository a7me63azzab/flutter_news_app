import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  StoriesBloc() {
    _itemsFetcher.stream
        .transform(_itemsTransformer())
        .where((item) => item != null)
        .pipe(_itemsOutput);
  }

  // Retrieve data from stream
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  //Add data to stream
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel>> cache, int id, _) {
      cache[id] = _repository.fetchItem(id);
      // cache[id].then((value) => print('=========> ${value.title}'))
      // .catchError((err)=>print('xxxxxx=> $err'));
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  void dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
