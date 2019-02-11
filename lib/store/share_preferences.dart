import 'package:shared_preferences/shared_preferences.dart';
import '../model/Category.dart';
class SharePreferenceUtils {

  //设置token
  static saveToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString("token", token);
  }

  static getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.get("token");
  }

  ///设置 选中的 栏目
  static saveCategory(int category,String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("category", category);
    await preferences.setString("categoryName", name);
    return ;
  }
  ///获取选中的栏目
  static getCategory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int id  = await preferences.get("category");

    if (id == null){
      return null;
    }
    String name  = await preferences.get("categoryName");
    return new Category(id,name);
  }


}
