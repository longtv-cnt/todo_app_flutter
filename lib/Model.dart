// model class for todo
class TodoModel {
  int? id;
  String? title;
  String? description;
  String? dateandtime;
  bool? isCompleted;
  TodoModel(
      {this.id,
      this.title,
      this.description,
      this.dateandtime,
      this.isCompleted = false});
  TodoModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    dateandtime = map['dateandtime'];
    isCompleted = map['isCompleted'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateandtime': dateandtime,
      
    };
  }
}
