import 'package:barka/models/chaptersTaken.dart';

class User {
  final String uid;
  final String name;
  final List<ChaptersTaken> chaptersTaken;

  User({this.uid, this.name, this.chaptersTaken});
}
