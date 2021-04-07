import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/dao/dao_result.dart';
import 'package:gsy_github_app_flutter/common/dao/recommend_dao.dart';

class TodayBloc extends ChangeNotifier {
  DataResult todayRecommend = new DataResult(null, false);
  TodayBloc() {
    this.init();
  }

  init() async {
    DataResult res = await RecommendDao.today();
    todayRecommend = res;
    notifyListeners();
  }
}
