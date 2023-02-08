import 'choices.dart';

class Chapters {
  String? name;
  String? image;
  List<Choices>? choices;
  String? content;
  String? id;

  Chapters({this.name, this.image, this.choices, this.content, this.id});

  Chapters.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    if (json['choices'] != null) {
      choices = <Choices>[];
      json['choices'].forEach((v) {
        choices!.add(Choices.fromJson(v));
      });
    }
    content = json['content'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    if (choices != null) {
      data['choices'] = choices!.map((v) => v.toJson()).toList();
    }
    data['content'] = content;
    data['id'] = id;
    return data;
  }
}
