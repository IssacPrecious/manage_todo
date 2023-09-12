import 'dart:convert';

class ToDos {
  final String title, description;

  ToDos({
    required this.title,
    required this.description,
  });

  factory ToDos.fromJson(Map<String, dynamic> jsonData) {
    return ToDos(
      title: jsonData['title'],
      description: jsonData['description'],
    );
  }

  static Map<String, dynamic> toMap(ToDos toDos) => {
        'title': toDos.title,
        'description': toDos.description,
      };

  static String encode(List<ToDos> musics) => json.encode(
        musics.map<Map<String, dynamic>>((music) => ToDos.toMap(music)).toList(),
      );

  static List<ToDos> decode(String toDos) =>
      (json.decode(toDos) as List<dynamic>).map<ToDos>((item) => ToDos.fromJson(item)).toList();
}
