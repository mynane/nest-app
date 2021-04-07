import 'package:gsy_github_app_flutter/common/dao/dao_result.dart';
import 'package:gsy_github_app_flutter/common/net/address.dart';
import 'package:gsy_github_app_flutter/common/net/api.dart';

class AllDao {
  static all() async {
    var res = await httpManager.netFetch(Address.getHome(), null, null, null);

    return new DataResult(res!.data, res.result);
  }
}
