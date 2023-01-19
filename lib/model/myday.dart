
class MydayInfo {
  int? id;
  final String title;
  final String description;


  MydayInfo({
    this.id,
    required this.title,
    required this.description,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      // it doesn't support the boolean either, so we save that as integer.
    };
  }

  // this function is for debugging only
  @override
  String toString() {
    return 'Todo(id : $id, title : $title, description : $description)';
  }
}