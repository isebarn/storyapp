import 'package:http/http.dart' as http;
import 'package:story_teller/helpers/http_response.dart';
import 'package:story_teller/models/story_response.dart';
import 'dart:convert';

Future<HttpResponse<List<StoryResponse>>> fetchStories() async {
  final httpResponse = await http
      .get(
        Uri.parse(
          'https://storyapi.isebarn.com/api/story?\$include=chapters,chapters__choices',
        ),
      )
      .catchError(
        (err) => throw ('check your internet connection $err'),
      );
  var responseBody = json.decode(utf8.decode(httpResponse.bodyBytes));

  if (httpResponse.statusCode != 200) {
    String message = responseBody['message'];
    return HttpResponse.error(message);
  }

  return HttpResponse.completed(
    (responseBody
        .map<StoryResponse>(
          (story) => StoryResponse.fromJson(
            story,
          ),
        )
        .toList() as List<StoryResponse>),
  );
}
