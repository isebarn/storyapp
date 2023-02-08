import 'package:flutter/material.dart';
import 'package:story_teller/helpers/http_response.dart';
import 'package:story_teller/models/story_response.dart';
import 'package:story_teller/services/story_service.dart';

import 'models/chapters.dart';

HttpResponse? stories;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story Teller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MyHomePage(),
        StoryDetail.routeName: (context) => const StoryDetail(
              chapterId: '',
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      stories = await fetchStories();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<StoryResponse>? data = (stories?.responseBody as List<StoryResponse>?);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Teller'),
      ),
      body: (stories == null)
          ? const SizedBox()
          : ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(
                    8,
                  ),
                  title: Text(
                    data![index].name!,
                  ),
                  leading: Image.network(
                    data[index].image!,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      StoryDetail.routeName,
                      arguments: data[index],
                    );
                  },
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        StoryDetail.routeName,
                        arguments: data[index],
                      );
                    },
                    child: Container(
                      color: Colors.blueAccent.shade100,
                      padding: const EdgeInsets.all(
                        8,
                      ),
                      child: const Text(
                        'Read Story',
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class StoryDetail extends StatelessWidget {
  static const routeName = 'story_detail';
  final String chapterId;

  const StoryDetail({Key? key, required this.chapterId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final story = ModalRoute.of(context)!.settings.arguments as StoryResponse;
    return Scaffold(
      appBar: AppBar(
        title: Text(story.name!),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            story.chapters!.firstWhere((chapter) => chapter.id == chapterId,
                    orElse: () {
                  return story.chapters!.first;
                }).image ??
                story.image ??
                '',
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              removeAllHtmlTags(
                story.chapters!.firstWhere((chapter) => chapter.id == chapterId,
                    orElse: () {
                  return story.chapters!.first;
                }).content!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: getChoices(
                  context,
                  story,
                  story.chapters!.firstWhere(
                      (chapter) => chapter.id == chapterId, orElse: () {
                    return story.chapters!.first;
                  })),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> getChoices(
    BuildContext context,
    StoryResponse storyResponse,
    Chapters chapter,
  ) {
    List<Widget> choices = [];
    for (var choice in chapter.choices!) {
      choices.add(
        GestureDetector(
          onTap: () {
            if (choice.chapter != null) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) {
                    return StoryDetail(
                      chapterId: choice.chapter!.id!,
                    );
                  },
                  settings: RouteSettings(
                    arguments: storyResponse,
                  ),
                ),
                ModalRoute.withName('/'),
              );
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            color: Colors.blueAccent.shade100,
            padding: const EdgeInsets.all(
              8,
            ),
            child: Text(
              choice.text!,
            ),
          ),
        ),
      );
    }
    return choices;
  }
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}
