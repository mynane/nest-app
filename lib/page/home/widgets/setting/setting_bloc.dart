import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/common/dao/dao_result.dart';
import 'package:gsy_github_app_flutter/common/dao/recommend_dao.dart';
import 'package:gsy_github_app_flutter/common/dao/user_dao.dart';

class SettingBloc extends ChangeNotifier {
  DataResult userInfo = new DataResult(null, false);
  SettingBloc() {
    this.init();
  }

  init() async {
    userInfo = await UserDao.getUserInfo(null);
    notifyListeners();
  }
}
