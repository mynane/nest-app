import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gsy_github_app_flutter/page/home/widgets/search/search_page.dart';
import 'package:gsy_github_app_flutter/page/home/widgets/today/today_bloc.dart';
import 'package:gsy_github_app_flutter/redux/gsy_state.dart';
import 'package:gsy_github_app_flutter/redux/login_redux.dart';

class TodayPage extends StatefulWidget {
  TodayPage({Key? key}) : super(key: key);

  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  late TodayBloc todayBloc;
  EasyRefreshController _controller = new EasyRefreshController();
  int _count = 0;

  @override
  void initState() {
    todayBloc = new TodayBloc();
    todayBloc.addListener(() {
      // print(todayBloc.todayRecommend.data!["data"]);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    todayBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<GSYState>(
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(
            // title: Text("123123"),
            backgroundColor: store.state.themeData!.primaryColor,
            actions: [
              InkWell(
                child: Icon(Icons.search),
                onTap: () {
                  showSearch(context: context, delegate: SearchBarDelegate());
                },
              ),
            ],
          ),
          body: EasyRefresh.custom(
            enableControlFinishRefresh: true,
            enableControlFinishLoad: true,
            controller: _controller,
            firstRefresh: true,
            firstRefreshWidget: Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                  child: SizedBox(
                height: 200.0,
                width: 300.0,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        child: Text("数据加载中"),
                        // SpinKitFadingCube(
                        //   color: Theme.of(context).primaryColor,
                        //   size: 25.0,
                        // ),
                      ),
                      Container(
                        child: Text("数据加载中"),
                      )
                    ],
                  ),
                ),
              )),
            ),
            emptyWidget: _count == 0
                ? Container(
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(),
                          flex: 2,
                        ),
                        // SizedBox(
                        //   width: 100.0,
                        //   height: 100.0,
                        //   child: Image.asset('assets/image/nodata.png'),
                        // ),
                        Text(
                          "暂无数据",
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey[400]),
                        ),
                        Expanded(
                          child: SizedBox(),
                          flex: 3,
                        ),
                      ],
                    ),
                  )
                : null,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Text('123123123');
                  },
                  childCount: _count,
                ),
              ),
            ],
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2), () {
                if (mounted) {
                  setState(() {
                    _count = 20;
                  });
                  _controller.resetLoadState();
                  _controller.finishRefresh();
                }
              });
            },
            onLoad: () async {
              await Future.delayed(Duration(seconds: 2), () {
                if (mounted) {
                  setState(() {
                    _count += 20;
                  });
                  _controller.finishLoad(noMore: _count >= 80);
                }
              });
            },
          ),
        );
      },
    );
  }
}
