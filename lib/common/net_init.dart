import '../api/net/appSrv.dart';
import '../api/net/useinfosrv.dart';
import '../common/Toast.dart';
import '../model/Category.dart';
import '../model/app_response.dart';
import '../model/userinfo.dart';
import '../provide/single_global_instance/appstate_bloc.dart';

//初始化 网络请求 参数
class NetInit {
  static bool isLoading = false;

  ///初始化登录操作。
  initAppState() async {
    if (isLoading) {
      ToastUtils.show("正在加载...");
      return;
    }
    isLoading = true;
    AppResponse examType = await AppSrv.getOemExamTypeList();
    if (examType.code == 200) {
      var bean = examType.result[0];
      List children = bean['children'];
      List<Category> categoryList = children.map((m) => new Category.fromJson(m)).toList();
      appStateBloc.setCategory(categoryList);
    }

    AppResponse appResponse = await AppSrv.versionInfo();

    if (appResponse.code == 200) {
      appResponse = await UserInfoSrv.checkLogin();
      if (appResponse.code == 200) {
        appResponse = await UserInfoSrv.getUserInfo();
        if (appResponse.code == 200) {
          UserInfo userInfo = UserInfo.fromJson(appResponse.result);
          appStateBloc.setUerInfo(userInfo);
        } else {
          ToastUtils.show(appResponse.msg);
        }
      } else {
        ToastUtils.show(appResponse.msg);
      }
    } else {
      ToastUtils.show(appResponse.msg);
    }
    isLoading = false;
  }
}

NetInit netInit = new NetInit();
