import 'package:gsy_github_app_flutter/common/dao/dao_result.dart';
import 'package:gsy_github_app_flutter/common/net/address.dart';
import 'package:gsy_github_app_flutter/common/net/api.dart';

class RecommendDao {
  static today() async {
    var res =
        await httpManager.netFetch(Address.getRecommend(), null, null, null);

    return new DataResult(res!.data, res.result);
  }
}
