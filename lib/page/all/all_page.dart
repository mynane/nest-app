import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/config/application.dart';
import 'package:gsy_github_app_flutter/config/routes.dart';
import 'package:gsy_github_app_flutter/page/all/all_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:date_format/date_format.dart';

class AllPage extends StatefulWidget {
  AllPage({Key? key}) : super(key: key);

  @override
  _AllPageState createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  AllBloc allBloc = new AllBloc();

  List<String> getDataList() {
    List<String> list = [];
    for (int i = 0; i < 100; i++) {
      list.add(i.toString());
    }
    return list;
  }

  List<Widget> getWidgetList() {
    if (allBloc.loadHomeDataContoller.dataList!.data != null) {
      dynamic lists =
          allBloc.loadHomeDataContoller.dataList!.data["problems"]["data"];
      return lists.map<Widget>((item) => getItemContainer(item)).toList();
    }

    return [];
  }

  void _onTileClicked(Map<String, dynamic> item) {
    final id = item["_id"];
    final title = item["title"];
    final url = Uri.encodeComponent(
        "http://106.12.99.114/list?id=${id}&title=${title}");
    Application.router.navigateTo(
      context,
      "${Routes.webview}?url=${url}",
      transition: TransitionType.fadeIn,
    );
    debugPrint("You tapped on item $item['title']");
  }

  Widget getItemContainer(Map<String, dynamic> item) {
    return GridTile(
      child: InkResponse(
        onTap: () => _onTileClicked(item),
        enableFeedback: true,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.ac_unit,
                  color: Colors.black12,
                  size: 40,
                ),
              ),
              Text(
                item["title"],
                style: TextStyle(color: Colors.black26, fontSize: 14),
              ),
            ],
          ),
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Widget cardItem(String title, int diff, String id, String type) {
    final showDiff = diff == 0 ? "今天" : "$diff天前";
    return InkWell(
      onTap: () {
        final url =
            Uri.encodeComponent("http://106.12.99.114/${type}?id=${id}");
        Application.router.navigateTo(
          context,
          "${Routes.webview}?url=${url}",
          transition: TransitionType.fadeIn,
        );
      },
      // enableFeedback: true,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              // color: Colors.indigoAccent[100],
              color: Color.fromRGBO(0, 0, 0, 0.1),
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title), Text(showDiff)],
        ),
      ),
    );
  }

  Widget getGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      //水平子Widget之间间距
      crossAxisSpacing: 1,
      //垂直子Widget之间间距
      mainAxisSpacing: 1,
      //GridView内边距
      padding: EdgeInsets.all(1),
      //一行的Widget数量
      crossAxisCount: 3,
      //子Widget宽高比例
      childAspectRatio: 1.0,
      //子Widget列表
      children: getWidgetList(),
    );
  }

  Widget recommendList() {
    if (allBloc.loadHomeDataContoller.dataList!.data != null) {
      dynamic lists =
          allBloc.loadHomeDataContoller.dataList!.data["recommends"]["data"];
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: lists.length,
        itemBuilder: (context, index) {
          final date1 = DateTime.parse(lists[index]['create_at'])
              .add(new Duration(hours: 8));
          String title = formatDate(date1, [yyyy, '-', mm, '-', dd]).toString();

          final date2 = DateTime.now().add(new Duration(hours: 8));
          final difference = date2.difference(date1).inDays;
          return cardItem(title, difference, lists[index]["_id"], 'recommend');
        },
      );
    }

    return Text("");
  }

  Widget testsList() {
    if (allBloc.loadHomeDataContoller.dataList!.data != null) {
      dynamic lists =
          allBloc.loadHomeDataContoller.dataList!.data["tests"]["data"];
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: lists.length,
        itemBuilder: (context, index) {
          final item = lists[index];
          final date1 =
              DateTime.parse(item['create_at']).add(new Duration(hours: 8));
          String title = formatDate(date1, [yyyy, '-', mm, '-', dd]).toString();

          final date2 = DateTime.now().add(new Duration(hours: 8));
          final difference = date2.difference(date1).inDays;
          return cardItem(item["title"], difference, item["_id"], 'testsList');
        },
      );
    }

    return Text("");
  }

  @override
  void initState() {
    allBloc.loadHomeDataContoller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            getGridView(),
            recommendList(),
            testsList(),
          ],
        ),
      ),
    );
  }
}
