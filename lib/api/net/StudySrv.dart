import '../../api/diobase.dart';
import '../../model/app_response.dart';

class StudySrv {
  static Future<AppResponse> getCourseInfo(int courseId) async {
    return ApiManager.instance.netFetch({
      "url":
          '/knew/pc/Course/getLessonListByCourseId/courseId/${courseId.toString()}'
    });
  }

  /// 获取课时信息
  /// @param courseId 课程id
  ///@param lessonId 课时id

  static getLessonInfo(int courseId, String lessonId) {
    return ApiManager.instance.netFetch({
      "url": '/knew/pc/Course/getLessonInfo',
    }, params: {
      "courseId": courseId.toString(),
      "lessonId": lessonId,
    });
  }
}
