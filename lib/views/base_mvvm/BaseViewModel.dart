import 'dart:async';

abstract class BaseViewModel<T> {
  // 初始化加载 成功。
  bool loadingState;

  var loadingStateController = StreamController<bool>.broadcast();

  Sink get loadingStateSink => loadingStateController;

  Stream get outputLoadingStateStream => loadingStateController.stream;

  BaseViewModel() {
    loadingState = iniLoadingState();
  }

  setLoading(bool state) {
    loadingState = state;
    loadingStateSink.add(loadingState);
  }

  bool iniLoadingState() {
    return true;
  }




  var _dataSourceController = StreamController<T>.broadcast();

  Sink get inputData => _dataSourceController;

  Stream get outputData => _dataSourceController.stream;

  dispose() {
    _dataSourceController.close();
    loadingStateController.close();
  }
}
