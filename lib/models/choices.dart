import 'chapter.dart';

class Choices {
  String? text;
  Chapter? chapter;
  String? id;

  Choices({this.text, this.chapter, this.id});

  Choices.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    chapter =
        json['chapter'] != null ? Chapter.fromJson(json['chapter']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    if (chapter != null) {
      data['chapter'] = chapter!.toJson();
    }
    data['id'] = id;
    return data;
  }
}
