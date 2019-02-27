

class StudyResource {
  int id;
  String title;
  String courseType;
  int subjectID;


  StudyResource(this.id, this.title);

  StudyResource.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    courseType = json['courseType'];
    subjectID = json['subjectID'];
  }

  @override
  String toString() {
    return 'StudyResource{id: $id, title: $title, courseType: $courseType, subjectID: $subjectID}';
  }
}
