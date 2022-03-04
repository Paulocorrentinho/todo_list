class Todo {
  Todo({required this.title, required this.dateTime});

  Todo.fromjson(Map<String, dynamic> json)
   : title = json['title'],
     dateTime = DateTime.parse(json['datetime']);     //converte json para datetime

  String title;
  DateTime dateTime;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'datetime': dateTime.toIso8601String(),     //converte o datetime para json
    };
  }

}
