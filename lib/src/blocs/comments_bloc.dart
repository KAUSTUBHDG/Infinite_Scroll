import 'package:rxdart/rxdart.dart';
import 'dart:async';
import '../models/item_models.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _repository = Repository();

  get itemWithComments => _commentsOutput.stream;

  get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransform())
        .pipe(_commentsOutput);
  }

  _commentsTransform() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
        (cache, int id, index) {
      cache[id] = _repository.fetchItem(id);
      cache[id].then(
        (ItemModel item) {
          item.kids.forEach(
            (kidId) => fetchItemWithComments(kidId),
          );
        },
      );
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  void dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
