import 'package:flutter/material.dart';
import 'package:flutterkaoyaya/api/net/liveMicroSrv.dart';
import 'package:flutterkaoyaya/common/Toast.dart';
import 'package:flutterkaoyaya/common/routeUtils.dart';
import 'package:flutterkaoyaya/components/loading.dart';
import 'package:flutterkaoyaya/components/my_live_item.dart';
import 'package:flutterkaoyaya/model/LiveBean.dart';
import 'package:flutterkaoyaya/model/app_response.dart';

class RecentLive extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RecentLive();
  }
}

class _RecentLive extends State<RecentLive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<PreLiveBean> preLiveList = [];

  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() {
    initGetMyPreLive();
  }

  initGetMyPreLive() async {
    AppResponse response = await LiveMicroSrv.getMyPreLive();
    if (response.code != 200) {
      ToastUtils.show(response.msg);
      isLoading = false;
      setState(() {

      });
      return;
    }
    List list = response.result;
    preLiveList = list.map((m) => new PreLiveBean.fromJson(m)).toList();
    if (mounted) {
      isLoading = false;
      setState(() {
        preLiveList = preLiveList;
      });
    }
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      new Container(
        color: Color(0XFFeef0f5),
        child: RefreshIndicator(
            child: ListView.builder(
              itemBuilder: (content, index) {
                PreLiveBean bean = preLiveList[index];
                return MyPreLiveItem(
                  bean: bean,
                  function: (PreLiveBean dat) {
                    RouteUtils.instance.goLive2(context, bean.access,
                        bean.startTime, bean.free, bean.mediaId, "live");
                  },
                );
              },
              itemCount: preLiveList.length,
              padding: EdgeInsets.all(10),
            ),
            onRefresh: _onRefresh),
      ),
      Loading(isLoading)
    ],);
  }
}
