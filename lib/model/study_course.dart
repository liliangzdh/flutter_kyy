

class StudyResource {
  int id=0;
  String title="";
  String courseType="";
  int subjectID=0;


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
