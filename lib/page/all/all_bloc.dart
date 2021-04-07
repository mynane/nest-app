import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/dao/all_dao.dart';
import 'package:gsy_github_app_flutter/common/dao/dao_result.dart';

class LoadHomeDataContoller extends ChangeNotifier {
  DataResult _dataList = new DataResult(null, false);

  DataResult? get dataList => _dataList;

  set dataList(DataResult? value) {
    if (value != null) {
      _dataList = value;
      notifyListeners();
    }
  }

  addList(DataResult? value) {
    if (value != null) {
      _dataList = value;
      notifyListeners();
    }
  }
}

class AllBloc {
  LoadHomeDataContoller loadHomeDataContoller = new LoadHomeDataContoller();

  AllBloc() {
    this.init();
  }

  init() async {
    var res = await AllDao.all();

    loadHomeDataContoller.addList(res);
  }

  void dispose() {
    loadHomeDataContoller.dispose();
  }
}
