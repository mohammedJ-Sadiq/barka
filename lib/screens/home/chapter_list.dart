import 'package:barka/models/chapter_assignment.dart';
import 'package:barka/screens/home/chapter_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapterList extends StatefulWidget {
  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  @override
  Widget build(BuildContext context) {
    final chapters = Provider.of<List<ChapterAssignment>>(context) ?? [];
    print(chapters);
    return ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: ChapterTile(
              chapter: chapters[index],
            ),
          );
        });
  }
}
