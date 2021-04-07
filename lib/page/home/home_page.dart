import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_github_app_flutter/page/home/widgets/setting/setting_page.dart';
import 'package:gsy_github_app_flutter/page/home/widgets/today/today_page.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';

class HomePage extends StatefulWidget {
  static final String sName = "home";
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> _children = [TodayPage(), Text("2"), Text("3"), SettingPage()];

  onTabTapped(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<GSYState>(
      builder: (context, store) {
        Color primaryColor = store.state.themeData!.primaryColor;
        return new Scaffold(
          body: _children[_currentIndex],
          // CupertinoTabBar 是IOS分格
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                label: "今天",
                icon: new Icon(Icons.today),
                backgroundColor: primaryColor,
              ),
              BottomNavigationBarItem(
                label: "全部",
                icon: new Icon(Icons.list),
                backgroundColor: primaryColor,
              ),
              BottomNavigationBarItem(
                label: "消息",
                icon: new Icon(Icons.message),
                backgroundColor: primaryColor,
              ),
              BottomNavigationBarItem(
                label: "账号",
                icon: new Icon(Icons.settings),
                backgroundColor: primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
