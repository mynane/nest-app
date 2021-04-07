import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_github_app_flutter/common/localization/default_localizations.dart';
import 'package:gsy_github_app_flutter/page/home/widgets/setting/setting_bloc.dart';
import 'package:gsy_github_app_flutter/page/home/widgets/setting/user_profi.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';
import 'package:gsy_github_app_flutter/redux/login_redux.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late SettingBloc settingBloc;

  @override
  void initState() {
    settingBloc = new SettingBloc();
    settingBloc.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    settingBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(settingBloc.userInfo.data);
    return StoreBuilder<GSYState>(
      builder: (context, store) {
        final primaryColor = store.state.themeData!.primaryColor;
        return Scaffold(
          body: UserProfilePage(),
        );
      },
    );
  }
}
