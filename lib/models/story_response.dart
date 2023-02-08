import 'chapters.dart';

class StoryResponse {
  String? name;
  String? image;
  List<Chapters>? chapters;
  String? id;

  StoryResponse({this.name, this.image, this.chapters, this.id});

  StoryResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    if (json['chapters'] != null) {
      chapters = <Chapters>[];
      json['chapters'].forEach((v) {
        chapters!.add(Chapters.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    if (chapters != null) {
      data['chapters'] = chapters!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}
