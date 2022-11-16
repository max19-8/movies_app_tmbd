
class PaginatorLoadResult<T>{
  final  List<T> data;
  final int currentPage;
  final int totalPage;

  PaginatorLoadResult({required this.data,required  this.currentPage, required this.totalPage});
}

typedef PaginatorLoad<T> =  Future<PaginatorLoadResult<T>>Function(int);


class Paginator<T>{
  final PaginatorLoad<T> load;
  Paginator(this.load);

  final _data = <T>[];

  late int _currentPage;
  late int _totalPage;
  var _isLoadingInProgress = false;
  List<T> get data => _data;


  Future<void> loadNextPage() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final response = await load(nextPage);
      _data.addAll(response.data);
      _currentPage = response.currentPage;
      _totalPage = response.totalPage;
      _isLoadingInProgress = false;
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoadingInProgress = false;
    }
  }

  Future<void> reset() async {
    _currentPage = 0;
    _totalPage = 1;
    _data.clear();
 //   await loadNextPage();
  }
}